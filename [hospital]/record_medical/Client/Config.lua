-- Keyboard configuration
config_keys = {
    moveUP = 172,       -- default 172
    moveDown = 173,     -- default 173
    moveLeft = 174,     -- default 174
    moveRight = 175,    -- default 175
    enter = 176,        -- default 176
    back = 177          -- default 177
}

-- Whem activated, the medical Record will disappear whem the box appears
-- To enter the information.
-- This is recommended for users with low screen resolution
-- or whem the position of the card is more centralized.
hiddenWhenWriting = true

-- Change the value of these variables according to your language.
translate = {
    TR_FICHA_MEDICA           = "Ficha medica",
    TR_NOME_HOSPITAL          = "Hospital Memorial Elysium",
    TR_BUTTON_PESQUISAR       = "Procurar",
    TR_BUTTON_REGISTRAR       = "Registrar",
    TR_TEXT_CONSULTAS_1       = "Atendimento",
    TR_TEXT_CONSULTAS_2       = "Nos cuidamos de voce!",--
 
    TR_PESQUISA_TITULO        = "Procurar por",
    TR_PESQUISA_ID            = "RG",
    TR_PESQUISA_NOME          = "Nome",
    TR_PESQUISA_ALL           = "Pesquisar pacientes",--
 
    TR_RESULTADO_TITULO       = "Paciente encontrado",
    TR_COUNT_CONSULTA_TEXT_1  = "Consultado",
    TR_COUNT_CONSULTA_TEXT_2  = "Vezes",
    TR_NAO_ENCONTRADO         = "Paciente nao encontrado",--
 
    TR_PACIENTE_N_CONSULTA    = "Consulta Nº",
    TR_SANGUE_CONSULTA        = "Informar tipo sanguineo:",
    TR_SANGUE_TIPO            = "Tipo sanguineo",
    TR_MOTIVO_CONSULTA        = "Motivo da consulta:",
    TR_DESCRICAO_CONSULTA     = "Descricao medica:",--
 
    TR_REGISTRO_TITULO        = "Novo registro",
    TR_MAX_CARACTERES         = "Max 200 caracteres"
}

-- medical record settings
config = {
    CFG_POSITION_X            = "90%", -- default "90%"
    CFG_POSITION_Y            = "50%", -- default "50%"

    -- Size of the medical record in proportion ( recommended from 0.8 to 1.0 )
    CFG_SIZE                  = "1.0", -- default "1.0"

    -- This will change the identification color of what is beign selected 
    -- You can also use hexadecimal values as na example: #444444FF
    CFG_COR_SELECT            = "rgba(23, 94, 248, 0.705)", -- default = "rgba(23, 94, 248, 0.705)"

    -- Place the LOGO image of your server or a hospital here
    -- Recommended size: ( 128x128 px )
    -- Acceptable types: png, jpg e gif. If you want add another type
    -- add 'html/img/*.TYPEHERE' to the file  fxmanifest.lua

    CFG_LOGO_IMG              = "./img/logo.png",
}
