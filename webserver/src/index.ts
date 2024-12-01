import { googleAuth } from "@hono/oauth-providers/google";
import { Hono } from "hono";
import { CookieStore, Session, sessionMiddleware } from "hono-sessions";
import { serveStatic } from "hono/bun";

const app = new Hono();

const store = new CookieStore()

app.use(sessionMiddleware({
    store,
    encryptionKey: Bun.env.AUTH_SECRET, // Required for CookieStore, recommended for others
    expireAfterSeconds: 900, // Expire session after 15 minutes of inactivity
    cookieOptions: {
        sameSite: 'Lax', // Recommended for basic CSRF protection in modern browsers
        path: '/', // Required for this library to work properly
        httpOnly: true, // Recommended to avoid XSS attacks
    },
}))

app.get('/google', googleAuth({
    client_id: Bun.env.GOOGLE_ID,
    client_secret: Bun.env.GOOGLE_SECRET,
    scope: ['openid', 'email', 'profile'],
}), (c) => {
    const token = c.get('token')

    if (!token) {
        return new Response('Unauthorized', { status: 401 })
    }

    const session = c.get('session' as any) as Session
    session.set('isAuthenticated', true)

    return c.redirect('/')
})

app.use('*', async (c, next) => {
    const session = c.get('session' as any) as Session
    const isAuthenticated = session.get('isAuthenticated')

    if (!isAuthenticated) {
        return c.redirect('/google')
    }

    await next()
})

app.use('/d2-sdk/*', serveStatic({
    root: 'docs', onNotFound: (path, c) => {
        console.log(`${path} is not found, you access ${c.req.path}`)
    },
    rewriteRequestPath: (path) => {
        return path.replace(/^\/d2-sdk/, '')
    }
}))


app.use('/', serveStatic({
    path: 'index.html'
}))


export default app;

