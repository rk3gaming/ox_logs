local resourcePath = GetResourcePath('ox_logs')
local locale = json.decode(LoadResourceFile('ox_logs', ('locales/%s.json'):format(Config.Locale)))

if not locale then
    print('^1Failed to load locale file^0')
    return
end

function GetLocale(key)
    local keys = {}
    for k in key:gmatch('[^.]+') do
        keys[#keys + 1] = k
    end
    
    local value = locale
    for i = 1, #keys do
        value = value[keys[i]]
        if not value then
            print('^1Missing locale key: ' .. key .. '^0')
            return key
        end
    end
    
    return value
end 