resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page "html/index.html"

client_scripts {
    'client/main.lua',
    'config.lua',
    'client/showroom.lua',
    'client/customshowroom.lua',
    --'client/job.lua',
}

server_scripts {
    'server/main.lua',
    --'server/job_server.lua',
    'config.lua'
}

files {
    'html/index.html',
    'html/style.css',
    'html/reset.css',
    'html/script.js',
    'html/img/*.png',
    'html/img/site-bg.jpg',
}