# Bemby — Emby keep-alive & check-in panel, one click on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/bemby-template)

**Bemby** is a self-hosted panel that keeps your Emby accounts active: scheduled
check-ins, automated watch sessions, and Telegram client jobs — all from one
small web panel with a built-in scheduler.

This repository packages [liveinaus/Bemby](https://github.com/liveinaus/Bemby)
(upstream, MIT licensed; UI and docs largely in Chinese) for one-click deployment
on Railway. The upstream description: *Telegram 客户端任务面板 ｜ Emby 账号签到保活面板 ｜
A panel to keep your Emby account active*.

## What gets deployed

- **One service** — the official upstream Docker image (`liveinaus/bemby:1.0.0`,
  pinned), Node.js + Express + Vue SPA + SQLite.
- **One volume** mounted at `/app/data` — the SQLite database (accounts, jobs,
  schedule history, settings) lives here and survives restarts and redeploys.
- **Public domain** on the panel port (the app reads Railway's `PORT`).

## Deploy

1. Click the deploy button above.
2. When the deploy finishes, open the panel's public domain.
3. Log in with username `admin` (or your `ADMIN_USERNAME`) and the generated
   `ADMIN_PASSWORD` from your service's **Variables** tab in Railway.
4. Change the admin password when prompted — the panel forces this on first
   login, because `ADMIN_DEFAULT_PASSWORD` is preset to the same generated value
   as `ADMIN_PASSWORD`.
5. Add your Emby server URL and account credentials inside the panel, then create
   check-in / keep-alive jobs and pick a schedule.

## Variables

| Variable | Required | Default | Notes |
|---|---|---|---|
| `JWT_SECRET` | Yes | auto-generated per deploy (`${{ secret(64, …) }}`) | Signs session tokens; never reuse across installs |
| `ADMIN_PASSWORD` | Yes | auto-generated per deploy (`${{ secret(24, …) }}`) | Initial admin password; the panel makes you replace it on first login |
| `ADMIN_DEFAULT_PASSWORD` | Yes | same generated value as `ADMIN_PASSWORD` | Upstream compares the entered password against this to decide whether to force a change; keeping the two equal turns the first login into a forced password change |
| `ADMIN_USERNAME` | No | `admin` (code default) | Set your own before first login if you like |
| `TZ` | No | `UTC` (code default) | IANA name, e.g. `Australia/Sydney` — controls the scheduler's clock |
| `TRUST_PROXY` | — | `1` (baked into the image) | Correct behind Railway's proxy; already set for you |

Emby server URL and Emby account credentials are **not** environment variables —
you add them through the panel UI (Accounts), and they are stored in the SQLite
database on your private volume.

## Terms of service — read this

Bemby is keep-alive tooling: it **automates activity** (check-ins, watch time,
Telegram client actions) on third-party services. Use it only on accounts and
servers you are entitled to use, and only where the upstream service's terms
permit it — some services prohibit automated sign-ins or simulated watch time.
Automating activity may violate those terms, and doing so is entirely at your
own risk. The authors of this template are not affiliated with Emby or the
upstream Bemby project.

## Cost

One small service (512 MB – 1 GB RAM) plus a small volume: roughly **$3–5/month**
on Railway's usage pricing.

## Troubleshooting

- **Login rejected** — the password is the generated `ADMIN_PASSWORD` in the
  Variables tab, not `changeme`. If you changed it in the panel and forgot it,
  set a new `ADMIN_PASSWORD`… note the panel stores a password hash in the DB
  after a change, so variable changes only apply on a fresh volume.
- **Check-ins never run** — the scheduler sleeps between runs. Check the job's
  schedule and the panel's log viewer; remember `TZ` defaults to UTC.
- **Wrong check-in times** — set `TZ` to your IANA timezone and redeploy.
- **Emby connection fails** — verify the server URL is reachable *from Railway's
  network* (public URL or correct internal hostname) and the credentials work.

## Updates

The image is pinned (`liveinaus/bemby:1.0.0`). To upgrade, bump the tag in the
`Dockerfile` and redeploy — your data survives on the `/app/data` volume.

## Local development

```bash
docker build -t bemby-railway .
docker run -p 3000:3000 -v bemby-data:/app/data \
  -e JWT_SECRET=$(openssl rand -hex 32) \
  -e ADMIN_PASSWORD=changeme bemby-railway
```

## License

Upstream Bemby is MIT licensed — see [LICENSE](./LICENSE). This packaging repo is
public domain / MIT; do whatever you like with the two files that are ours.
