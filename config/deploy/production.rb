# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server 'example.com', user: 'deploy', roles: %w{app db web}, my_property: :my_value
# server 'example.com', user: 'deploy', roles: %w{app web}, other_property: :other_value
# server 'db.example.com', user: 'deploy', roles: %w{db}



# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any  hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

set :stage, :production
server 'cprideshare.com', port: 6969, user: "deploy", roles: [:web, :app, :db], primary: true

set :branch, ENV["REVISION"] || ENV["BRANCH_NAME"] || "master"

# The server-based syntax can be used to override options:
# ------------------------------------
server 'cprideshare.com',
    user: 'deploy',
    roles: %w{web},
    ssh_options: {
     user: 'deploy', # overrides user setting above
     keys: %w(/home/deploy/.ssh/id_rsa),
     forward_agent: false,
     auth_methods: %w(publickey password),
     password: 'please use keys'
    }
