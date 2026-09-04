const SUPABASE_ORIGIN = 'https://bazjlrualnmbanmhiuau.supabase.co';
const ALLOWED_PREFIXES = ['/auth/v1/', '/rest/v1/'];
const ALLOWED_METHODS = new Set(['GET', 'HEAD', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS']);
const FORWARDED_REQUEST_HEADERS = [
  'accept',
  'apikey',
  'authorization',
  'content-type',
  'prefer',
  'range',
  'x-client-info',
  'x-supabase-api-version'
];
const FORWARDED_RESPONSE_HEADERS = [
  'content-type',
  'content-range',
  'range-unit',
  'preference-applied',
  'www-authenticate'
];

module.exports = async function handler(req, res) {
  res.setHeader('Cache-Control', 'no-store');

  if (!ALLOWED_METHODS.has(req.method)) {
    res.setHeader('Allow', [...ALLOWED_METHODS].join(', '));
    return res.status(405).json({ error: 'Method not allowed' });
  }

  if (req.method === 'OPTIONS') return res.status(204).end();

  const requestedPath = Array.isArray(req.query.path) ? req.query.path[0] : req.query.path;
  if (!requestedPath || !ALLOWED_PREFIXES.some(prefix => requestedPath.startsWith(prefix))) {
    return res.status(400).json({ error: 'Unsupported Supabase path' });
  }

  let upstreamUrl;
  try {
    upstreamUrl = new URL(requestedPath, SUPABASE_ORIGIN);
  } catch (_) {
    return res.status(400).json({ error: 'Invalid Supabase path' });
  }

  if (upstreamUrl.origin !== SUPABASE_ORIGIN) {
    return res.status(400).json({ error: 'Invalid Supabase origin' });
  }

  const headers = {};
  for (const name of FORWARDED_REQUEST_HEADERS) {
    const value = req.headers[name];
    if (value) headers[name] = value;
  }

  let body;
  if (!['GET', 'HEAD'].includes(req.method) && req.body !== undefined) {
    body = typeof req.body === 'string' || Buffer.isBuffer(req.body)
      ? req.body
      : JSON.stringify(req.body);
  }

  try {
    const upstream = await fetch(upstreamUrl, {
      method: req.method,
      headers,
      body,
      redirect: 'manual',
      signal: AbortSignal.timeout(15000)
    });

    for (const name of FORWARDED_RESPONSE_HEADERS) {
      const value = upstream.headers.get(name);
      if (value) res.setHeader(name, value);
    }

    const payload = Buffer.from(await upstream.arrayBuffer());
    return res.status(upstream.status).send(payload);
  } catch (error) {
    console.error('Supabase proxy request failed', error);
    return res.status(502).json({ error: 'Secure sign-in service is temporarily unreachable' });
  }
};
