-- Addon: Przymierze Wykletych
-- Dla WoW 1.12.1 (pełna kompatybilność)

PrzymierzeWykletych = {}

PrzymierzeWykletych.messages = {
    "Gildia <PRZYMIERZE WYKLETYCH> zaprasza wszystkich odwaznych do wspolnej zabawy!",
    "Dolacz do gildii <PRZYMIERZE WYKLETYCH> i raiduj na MC/BWL/AQ/NAXX!",
    "Gildia <PRZYMIERZE WYKLETYCH> szuka graczy gotowych na epickie przygody!",
    "Nie przegap okazji! Gildia <PRZYMIERZE WYKLETYCH> rekrutuje nowych bohaterow!",
    "Z gildia <PRZYMIERZE WYKLETYCH> raidowanie staje sie przyjemnoscia!",
    "Gildia <PRZYMIERZE WYKLETYCH> czeka na Ciebie na kolejnych rajdach!",
    "Dolacz do gildii <PRZYMIERZE WYKLETYCH> i baw sie razem z nami na MC/BWL/AQ/NAXX!",
    "Szukasz aktywnej gildii? Gildia <PRZYMIERZE WYKLETYCH> ma dla Ciebie miejsce!",
    "Razem z gildia <PRZYMIERZE WYKLETYCH> osiagniemy wiecej – dolacz juz dzis!",
    "Gildia <PRZYMIERZE WYKLETYCH> zaprasza do wspolnej zabawy i raidow!",
    "Gilda <PRZYMIERZE WYKLETYCH> zaproszo wszyjstkich gibkich chopow i diolch do wspolnyj zabawy - niy bojcie sie, u nos je wesolo jak na grubie po szychcie!",
    "Dolonz do gildii <PRZYMIERZE WYKLETYCH> i rajzuj z nami po MC BWL AQ NAXX - trza miec serce, a niy ino EQ!",
    "Gilda <PRZYMIERZE WYKLETYCH> szuko gryfnych ludzi na epickie przygody - niy musisz byc pro, byleby ci sie chcialo!",
    "Niy przegap okazji! <PRZYMIERZE WYKLETYCH> bierze nowych bohaterow - po rajdzie moze i na piwo sie skoczy!",
    "Z nami w <PRZYMIERZE WYKLETYCH> rajdowanie to sam miod i piwo - niy ma stresu, ino szpas i drop!",
    "Gilda <PRZYMIERZE WYKLETYCH> czeko na Ciebie na kolejnym rajdzie - przyjdz, bo bez Ciebie to jak karminadle bez kapusty!",
    "Dolonz do naszej brygady <PRZYMIERZE WYKLETYCH> - u nos kazdy cos umia, a razem to my jak familok, ino ze z lootu!",
    "Szukosz zywyj gildii? W <PRZYMIERZE WYKLETYCH> zawse sie cos dzieje - cy rajd, cy szpas, cy ino godanie na czacie!",
    "Z gildia <PRZYMIERZE WYKLETYCH> urobimy wiecej niz niejeden bohater z bajki - bo my robimy, niy godo!",
    "Kaj indziej mozesz i pogro, ale u nos w <PRZYMIERZE WYKLETYCH> je klimat - gryfno banda, dobre rajdy i kupa smiechu!",
    "Gildia <PRZYMIERZE WYKLETYCH> oferuje nowoczesna operacje zmiany gildii, jesli jeszcze sie niezdecydowalos, przemysl to teraz!"
}

PrzymierzeWykletych.responsemsg = "Wcale nie 'jedyna', jest tez PRZYMIERZE WYKLETYCH! Zapraszamy!"

local interval = 900
local timeSinceLast = 0
local initialized = false
local reponseEnabled = false
local spamFrequency = 0.0

local frame = CreateFrame("Frame", "PrzymierzeWykletychFrame")
frame:RegisterEvent("VARIABLES_LOADED")
frame:RegisterEvent("CHAT_MSG_CHANNEL")

local function Print(msg)
    if DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[Przymierze Wykletych]|r " .. msg)
    end
end

function PrzymierzeWykletych_SayRandom()
    local count = table.getn(PrzymierzeWykletych.messages)
    if count > 0 then
        local msg = PrzymierzeWykletych.messages[math.random(1, count)]
        SendChatMessage(msg, "YELL")
        pcall(SendChatMessage, msg, "CHANNEL", nil, 5)
        pcall(SendChatMessage, msg, "CHANNEL", nil, 4)
    end
end

frame:SetScript("OnEvent", function()
    if event == "VARIABLES_LOADED" then
        if initialized then return end
        initialized = true
        Print("siusiaki")
        Print("Addon aktywny. Co " .. interval .. " sekund powie losowy tekst. (/mow, /mowtime <sekundy>)")
        PrzymierzeWykletych_SayRandom()
    elseif event == "CHAT_MSG_CHANNEL" then
        local msg, sender, language, channelName = arg1, arg2, arg3, arg9
        if string.lower(channelName or "") == "world" then
            local text = string.lower(msg or "")
            if string.find(text, "zmiana warty") and string.find(text, "jedyna") and reponseEnabled then
                pcall(SendChatMessage, PrzymierzeWykletych.responsemsg, "CHANNEL", nil, 5)
                pcall(SendChatMessage, PrzymierzeWykletych.responsemsg, "CHANNEL", nil, 4)
            end
        end
    end
end)

frame:SetScript("OnUpdate", function()
    timeSinceLast = timeSinceLast + arg1
    if timeSinceLast >= interval then
        timeSinceLast = 0
        PrzymierzeWykletych_SayRandom()
    end
end)

SlashCmdList = SlashCmdList or {}

SLASH_MOW1 = "/mow"
SlashCmdList["MOW"] = function()
    PrzymierzeWykletych_SayRandom()
    Print("Powiedziano losowy tekst.")
end

SLASH_MOWRESPTOGGLE1 = "/mowresptoggle"
SlashCmdList["MOWRESPTOGGLE"] = function()
    responseEnabled = not responseEnabled
    Print("Responder na Zmiane Warty ustawiony na " .. str(responseEnabled) .. " .")
end

SLASH_MOWTIME1 = "/mowtime"
SlashCmdList["MOWTIME"] = function(msg)
    local t = tonumber(msg)
    if t and t > 0 then
        interval = t
        timeSinceLast = 0
        Print("Nowy interwal ustawiony na " .. t .. " sekund.")
    else
        Print("Uzycie: /mowtime <sekundy> (np. /mowtime 600)")
    end
end

SLASH_MOWHELP1 = "/mowhelp"
SlashCmdList["MOWHELP"] = function()
    Print("Dostepne komendy: /mow, /mowtime <sekundy>, /mowresptoggle /mowhelp.")
    Print("/mow - odpala od razu tekst na reklame")
    Print("/mowtime <sekundy> - konfiguruje pluign do uzytkowania jedynie co jakis czas (900 - 15 minut, 1800 - 30 minut, domyślnie - 15 minut)")
    Print("/mowresptoggle - włącza/wyłącza resp toggler na Zmiane Warty")
    Print("/mowhelp - wypirintowuje to co czytasz teraz")
end
