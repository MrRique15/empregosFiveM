local cfg = {}

--Only vehicle has this hash can transport

cfg.vehicle = "-1207771834"
cfg.vehicleName = "rebel"


--Amount receive after put delivered
cfg.amount = 250

--Id blip
cfg.blip = 27

--Color blip RGB
cfg.blipColor = { r=0, g=151, b=251 }

--Messages
cfg.messages = {
    initialize = "Siga o blip no seu GPS para carregar.",
    delivery = "Siga blip no seu GPS para entregar carga.",
    getItem = "Pressione ~g~E~w~ para pegar a cargo.",
    putVeh = "Pressione ~g~E~w~ para colocar a carga no veiculo.",
    getVeh = "Pressione ~r~Q~w~ para retirar a carga do veiculo.",
    deliveryItem = "Pressione ~g~E~w~ para entregar a carga.",
    notVehicle = "Esse veículo não consegue transportar o objeto.",
    succefully = "Sua entrega foi realiza e você recebeu R$ " ..cfg.amount.." reais",
    continuar = "Para continuar o serviço digite /frete novamente.",
}

--Items can be transported
--item 
--          name | position relative for hands player | position relative for driver to the vehicle
cfg.items = {
    { "apa_mp_h_acc_plant_tall_01", -0.4, -1.3 },
    { "apa_mp_h_stn_chairarm_01", -0.4, -1.3 },
    { "gr_dlc_gr_yacht_props_seat_02", -0.4, -1.3 },
    { "apa_mp_h_stn_sofa_daybed_01", -0.8, -1.3 },
    { "apa_p_apdlc_treadmill_s", -0.8, -1.3 },
    { "bkr_prop_clubhouse_jukebox_01b", -0.4, -1.3 },
    { "bkr_prop_clubhouse_jukebox_02a", -0.4, -1.3 },
    { "bkr_prop_coke_doll_bigbox", -0.2, -1.3 },
    { "bkr_prop_meth_phosphorus", -0.4, -1.3 },
    { "gr_prop_gr_tool_chest_01a", -0.4, -1.3 },
    { "prop_arcade_01", -0.4, -1.3 },
    { "prop_ball_box", -0.4, -1.3 },
    { "prop_bbq_4_l1", -0.2, -1.3 },
    { "prop_bikini_disp_02", -0.1, -1.3 },
    { "prop_cleaning_trolly", -0.5, -1.3 },
    { "prop_coffin_02", -0.9, -1.3 },
    { "prop_copier_01", -0.5, -1.3 },
}

--locations for get/put cargo
cfg.locations = {
    vector3(-337.29309082031,-1027.0738525391,30.380876541138-0.9701),
    vector3(185.51741027832,-175.04156494141,54.145282745361-0.9701),
    vector3(151.75424194336,-72.828216552734,67.674766540527-0.9701),
    vector3(-305.87484741211,-121.1519241333,45.804122924805-0.9701),
    vector3(-862.99493408203,-255.01887512207,40.038478851318-0.9701),
    vector3(128.49076843262,341.60705566406,111.86670684814-0.9701),
    vector3(-309.60961914063,221.98989868164,87.926734924316-0.9701),
    vector3(-569.66796875,169.35797119141,66.566215515137-0.9701),
    vector3(-698.61584472656,46.943084716797,44.03377532959-0.9701),
    vector3(-729.0791015625,-223.56355285645,37.190784454346-0.9701),
    vector3(-658.00891113281,-679.09851074219,31.481733322144-0.9701),
    vector3(-1025.9379882813,-740.98400878906,19.869077682495-0.9701),
    vector3(-1462.8367919922,-704.63293457031,26.797813415527-0.9701),
    vector3(-1492.3397216797,-150.1591796875,52.508361816406-0.9701),
    vector3(-780.7021484375,270.4704284668,85.794174194336-0.9701),
    vector3(253.17510986328,-343.68338012695,44.520179748535-0.9701)
}

return cfg