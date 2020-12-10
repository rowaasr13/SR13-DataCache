local a_name, a_env = ...

a_env.a_export = {}

_G[a_name] = a_env.a_export
