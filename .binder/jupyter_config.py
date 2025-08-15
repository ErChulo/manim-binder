# Jupyter configuration for Binder
c = get_config()

# Server configuration
c.ServerApp.ip = '0.0.0.0'
c.ServerApp.port = 8888
c.ServerApp.open_browser = False
c.ServerApp.token = ''
c.ServerApp.password = ''
c.ServerApp.allow_origin = '*'

# Enable JupyterLab by default
c.ServerApp.default_url = '/lab'

# Increase timeout for Manim rendering
c.ServerApp.shutdown_no_activity_timeout = 3600

# File manager settings
c.ContentsManager.allow_hidden = True
