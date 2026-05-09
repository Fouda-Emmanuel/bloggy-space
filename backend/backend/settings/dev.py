from environs import Env
from os import path
env = Env()

from .base import * 
from .base import BASE_DIR


dev_env_file = path.join(BASE_DIR, ".envs", ".env.dev")

if path.isfile(dev_env_file):
    env.read_env(dev_env_file)


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/4.2/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = env("SECRET_KEY")

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = env.bool("DEBUG", default=False)

ALLOWED_HOSTS = env.list("ALLOWED_HOSTS")

CORS_ALLOWED_ORIGINS = env.list("CORS_ALLOWED_ORIGINS")

CSRF_TRUSTED_ORIGINS = env.list("CSRF_TRUSTED_ORIGINS")

# Stripe API Keys 
STRIPE_PUBLIC_KEY = env("STRIPE_PUBLIC_KEY")
STRIPE_SECRET_KEY = env("STRIPE_SECRET_KEY")

# Paypal API Keys 
PAYPAL_CLIENT_ID = env('PAYPAL_CLIENT_ID')
PAYPAL_SECRET_ID = env('PAYPAL_SECRET_ID')

FLUTTERWAVE_PUBLIC_KEY=env("FLUTTERWAVE_PUBLIC_KEY")
FLUTTERWAVE_PRIVATE_KEY=env("FLUTTERWAVE_PRIVATE_KEY")
FLUTTERWAVE_PRIVATE_KEY_LIVE=env("FLUTTERWAVE_PRIVATE_KEY_LIVE")
FLUTTERWAVE_ENCRYPTION_KEY=env("FLUTTERWAVE_ENCRYPTION_KEY")

RAVE_PUBLIC_KEY=env("RAVE_PUBLIC_KEY")
RAVE_SECRET_KEY=env("RAVE_SECRET_KEY")

PAYSTACK_PUBLIC_KEY=env("PAYSTACK_PUBLIC_KEY")
PAYSTACK_PRIVATE_KEY=env("PAYSTACK_PRIVATE_KEY")


ANYMAIL = {
    "MAILERSEND_API_TOKEN": env("MAILERSEND_API_TOKEN"),
}


FROM_EMAIL=env("FROM_EMAIL")
EMAIL_BACKEND=env("EMAIL_BACKEND")
DEFAULT_FROM_EMAIL=env("DEFAULT_FROM_EMAIL")
SERVER_EMAIL=env("SERVER_EMAIL")
EMAIL_HOST=env("EMAIL_HOST")
EMAIL_PORT=env("EMAIL_PORT")