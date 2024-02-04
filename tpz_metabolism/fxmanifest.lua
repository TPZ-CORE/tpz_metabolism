fx_version "adamant"

games {"rdr3"}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

version '1.0.0'

description 'TPZ-CORE Metabolism'

shared_scripts { 'config/*.lua', 'locales.lua' }

client_scripts { 'client/*.lua' }

server_scripts { 'server/*.lua' }

exports { "getThirst", "getHunger", "getAlcohol", "getStress" }

lua54 'yes'