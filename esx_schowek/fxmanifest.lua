fx_version 'adamant'

game 'gta5'

server_script {
    'server.lua',
    '@mysql-async/lib/MySQL.lua',

}

client_scripts {
    'config.lua',
    'client.lua'
}