from functools import partial
from lib.server import success, error, validate

APP_DIR = "/var/local/lib/cent/"

def compose(status, message, **data):
    base = {"status": status, 'message': message}
    if data:
        base['data'] = data
    return base

def validate(note: str | None = None):
    auth = request.headers.get("Authentication", "")
    if not auth:
        return error("Authentication is required to read/write notes")
    # do auth

    if not note is None:
        return True

    if not note:
        return error("Note ID is required")
    return True

success = partial(compose, 'success')
error = partial(compose, 'error')
warning = partial(compose, 'warning')

if __name__ == '__main__':

