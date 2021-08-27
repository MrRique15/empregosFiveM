Config = {}

Config.blipEmprego = {1206.43, -1465.46, 34.86}
Config.blipCaminhao = {1200.73, -1459.95, 34.77}
Config.caminhao = "firetruk"

-- Recompensa ao finalizar o trabalho
Config.valorMin = 200
Config.valorMax = 500

-- Tempo (em segundos) para novas missões aparecerem
Config.tempo = 120

-- Tempo (em segundos) que a pessoa tem que esperar para entrar em serviço novamente após sair de serviço
Config.cooldown = 240

Config.permissao = "false" -- Deixe como false caso não queira permissão (exemplo na linha abaixo)
-- Config.permissao = false

Config.locais = {
	
	-- Coord Mecanica
	
	{
		{544.52593994141,-182.71673583984,58.065170288086},
		{549.31774902344,-187.2911529541,54.481296539307},
		{548.9248046875,-191.64775085449,54.481296539307},
		{541.56115722656,-192.55183410645,54.481338500977},
		{539.26348876953,-186.40341186523,54.481334686279},
		{540.16265869141,-171.58285522461,54.896179199219},
		{549.70428466797,-172.99258422852,54.481342315674},
		{549.49108886719,-178.23043823242,54.481334686279},
		{548.95953369141,-182.76625061035,54.481334686279},
		{549.09729003906,-185.32983398438,54.481334686279},
		{543.22796630859,-183.43257141113,57.742900848389}
	},

	-- Coord Pier (Del Perro)

	{
		{-1611.2220458984,-998.00415039063,13.017387390137},
		{-1612.6381835938,-999.65795898438,15.474510192871},
		{-1611.7635498047,-996.29528808594,16.076471328735},
		{-1606.9204101563,-1000.206237793,16.074081420898},
		{-1611.2607421875,-1004.1708984375,13.017386436462},
		{-1603.2611083984,-1010.8825683594,13.017992973328},
		{-1605.3243408203,-1005.4752807617,13.017387390137},
		{-1600.9927978516,-1005.885559082,13.536538124084},
		{-1605.0330810547,-1002.5955200195,13.502998352051},
		{-1617.7073974609,-998.638671875,13.017385482788},
		{-1597.1896972656,-1007.0537719727,16.262489318848}
	},

	-- Coord Last Trains (Dinner)

	{
		{-371.56475830078,260.37176513672,85.83032989502},
		{-372.72741699219,259.14926147461,87.525527954102},
		{-375.98834228516,264.70068359375,84.986885070801},
		{-383.09609985352,259.87387084961,86.300239562988},
		{-364.4924621582,276.04592895508,89.947242736816},
		{-371.79946899414,274.46353149414,90.903564453125},
		{-377.73199462891,266.34027099609,89.920379638672},
		{-382.14663696289,260.63684082031,85.41487121582},
		{-374.65148925781,265.0813293457,84.98681640625},
		{-375.55120849609,262.99240112305,87.517318725586},
		{-361.96987915039,275.14535522461,86.421974182129}
	},

	-- Coord Casa 1 (Cidade)

	{
		{1289.3032226563,-1711.1575927734,55.477043151855},
		{1294.103515625,-1713.4460449219,55.078254699707},
		{1294.1895751953,-1712.0211181641,58.87833404541},
		{1288.2803955078,-1709.0733642578,61.62931060791},
		{1288.9616699219,-1719.8493652344,55.00163269043},
		{1300.7264404297,-1710.533203125,58.4573097229},
		{1287.3156738281,-1713.9547119141,55.061965942383},
		{1297.5451660156,-1711.7828369141,55.080284118652},
		{1286.8438720703,-1713.4770507813,57.820915222168},
		{1291.0773925781,-1711.3923339844,60.870155334473},
		{1301.8618164063,-1716.1309814453,54.365879058838}
	},

	-- Coord Casa 2 (Quase norte)

	{
		{-50.51961517334,1957.3980712891,190.15983581543},
		{-63.686664581299,1949.9975585938,190.1865234375},
		{-43.744533538818,1959.8175048828,190.35333251953},
		{-37.529373168945,1963.2584228516,190.1372833252},
		{-50.421195983887,1951.2080078125,190.18620300293},
		{-43.061817169189,1958.3294677734,194.24031066895},
		{-49.559326171875,1951.9609375,194.7932434082},
		{-34.788551330566,1963.5374755859,194.0255279541},
		{-64.737670898438,1947.9681396484,192.5555267334},
		{-57.662628173828,1943.0655517578,190.18914794922},
		{-50.550601959229,1967.8017578125,189.59797668457}
	},

	-- Coord Armazem 1 (Quase norte)

	{
		{1931.7327880859,4632.6171875,50.288318634033},
		{1928.2739257813,4633.6103515625,52.665817260742},
		{1922.7276611328,4619.2514648438,48.842105865479},
		{1934.5472412109,4634.6215820313,40.503173828125},
		{1935.6604003906,4631.7514648438,41.777503967285},
		{1935.3236083984,4625.3041992188,42.491527557373},
		{1935.7667236328,4617.5302734375,42.202209472656},
		{1938.1297607422,4620.0385742188,42.43860244751},
		{1932.5113525391,4609.38671875,40.321128845215},
		{1921.5046386719,4611.1420898438,40.283447265625},
		{1919.1860351563,4623.3881835938,40.783878326416}
	},

	-- Coord Casa 3

	{
		{879.65637207031,-205.18347167969,79.114318847656},
		{874.65191650391,-204.34812927246,75.964370727539},
		{891.94219970703,-208.03308105469,78.503677368164},
		{886.80859375,-211.21160888672,71.976455688477},
		{881.90606689453,-208.3159942627,71.976455688477},
		{875.87542724609,-203.0283203125,71.758277893066},
		{880.4287109375,-211.27526855469,71.590003967285},
		{883.79943847656,-217.60055541992,72.957504272461},
		{890.57708740234,-210.93695068359,71.976455688477},
		{895.63049316406,-201.68194580078,71.976455688477},
		{897.81292724609,-205.6967010498,73.440704345703}
	},

	-- Coord Dinner (Norte)

	{
		{1593.7598876953,6454.1484375,29.353921890259},
		{1590.2326660156,6449.9653320313,25.317142486572},
		{1585.5130615234,6451.7573242188,25.317148208618},
		{1580.5826416016,6454.1240234375,25.317165374756},
		{1580.6822509766,6457.8422851563,25.317140579224},
		{1586.0014648438,6467.0834960938,28.020065307617},
		{1593.6838378906,6459.4487304688,28.614826202393},
		{1587.4490966797,6461.7314453125,28.702602386475},
		{1582.3120117188,6459.4853515625,29.354553222656},
		{1585.572265625,6451.4287109375,28.418031692505},
		{1582.2612304688,6453.12890625,28.410095214844}
	},

	-- Coord Galinheiro (Norte)

	{
		{-67.272186279297,6264.529296875,31.090089797974},
		{-69.90837097168,6261.736328125,31.090126037598},
		{-75.783256530762,6264.4326171875,33.013679504395},
		{-66.646408081055,6270.2919921875,31.676355361938},
		{-92.280723571777,6261.4340820313,31.366992950439},
		{-97.015815734863,6258.3427734375,31.365753173828},
		{-94.359840393066,6258.74609375,35.368762969971},
		{-90.729362487793,6259.419921875,37.602561950684},
		{-96.399917602539,6255.6640625,37.618782043457},
		{-83.500877380371,6260.1474609375,32.356018066406},
		{-88.419044494629,6260.66796875,31.374759674072}
	},

	-- Coord Madereira  (Norte)

	{
		{-569.51947021484,5329.8471679688,71.097175598145},
		{-565.36865234375,5325.7631835938,73.621307373047},
		{-565.12677001953,5330.2817382813,75.965705871582},
		{-568.66302490234,5325.0375976563,71.011001586914},
		{-569.41821289063,5310.04296875,73.600021362305},
		{-574.18927001953,5311.30859375,71.394058227539},
		{-571.42474365234,5317.8588867188,71.177001953125},
		{-573.33135986328,5308.1049804688,71.767387390137},
		{-570.83538818359,5320.373046875,76.941276550293},
		{-570.32830810547,5323.7001953125,76.939277648926},
		{-560.82635498047,5342.4853515625,71.876625061035}
	},

	-- Coord Central Eletrica no Porto 

	{
		{37.910984039307,-2575.0190429688,8.677755355835},
		{30.617858886719,-2574.4621582031,9.2420644760132},
		{33.813247680664,-2566.5708007813,9.2420749664307},
		{38.734363555908,-2581.205078125,9.4240589141846},
		{14.65752696991,-2568.4470214844,9.2420635223389},
		{17.067762374878,-2561.1413574219,9.2420644760132},
		{18.541484832764,-2558.6882324219,6.005090713501},
		{28.740159988403,-2574.4909667969,6.005090713501},
		{16.653909683228,-2568.6254882813,6.0050902366638},
		{10.746321678162,-2575.0290527344,7.3238883018494},
		{35.566005706787,-2566.5051269531,6.0050859451294}
	},

	-- Coord Casa de Reabilitaçao (Mansao)

	{
		{-1500.5832519531,861.40441894531,181.59469604492},
		{-1504.2642822266,855.720703125,182.03196716309},
		{-1517.1879882813,851.52557373047,181.59465026855},
		{-1513.1153564453,853.11688232422,186.75885009766},
		{-1507.9157714844,856.03002929688,186.38743591309},
		{-1491.119140625,861.22003173828,187.17730712891},
		{-1516.3533935547,852.69195556641,189.9100189209},
		{-1522.9194335938,849.98529052734,185.78163146973},
		{-1525.4967041016,844.75177001953,186.12370300293},
		{-1520.8916015625,848.95989990234,181.59468078613},
		{-1512.3592529297,852.90716552734,181.59466552734}
	},

	-- Coord Central de Rede telefonica (Vinewood)

	{
		{778.22528076172,1283.7893066406,365.71276855469},
		{778.0048828125,1277.8685302734,365.78649902344},
		{780.85229492188,1274.8474121094,361.2841796875},
		{780.40966796875,1296.7886962891,361.42263793945},
		{764.73406982422,1274.455078125,362.65856933594},
		{760.29772949219,1280.4117431641,360.29647827148},
		{778.60363769531,1292.4854736328,365.31954956055},
		{764.25225830078,1293.1735839844,365.53594970703},
		{751.79461669922,1274.2954101563,362.61810302734},
		{751.12524414063,1274.5512695313,360.29647827148},
		{740.45007324219,1275.5377197266,361.89227294922}
	},

	-- Coord Casa mortuaria (cidade)

	{
		{411.94866943359,-1488.2047119141,30.149072647095},
		{419.78469848633,-1481.3114013672,30.150316238403},
		{404.49084472656,-1494.001953125,29.358125686646},
		{407.88845825195,-1499.3752441406,30.15013885498},
		{409.51412963867,-1489.0452880859,33.732345581055},
		{405.63235473633,-1491.5850830078,33.732345581055},
		{418.46075439453,-1479.193359375,33.415744781494},
		{409.85159301758,-1488.3447265625,38.019191741943},
		{419.81814575195,-1482.1574707031,38.328598022461},
		{407.16772460938,-1496.1988525391,39.967105865479},
		{413.55923461914,-1485.7990722656,38.081733703613}
	},

	-- Coord Igreja (Grove)

	{
		{14.879137039185,-1511.1501464844,37.782611846924},
		{17.325677871704,-1507.2742919922,40.514629364014},
		{21.56294631958,-1506.4163818359,38.936435699463},
		{20.559661865234,-1505.2724609375,31.850114822388},
		{25.507181167603,-1497.7264404297,31.003238677979},
		{16.873916625977,-1522.3223876953,29.29402923584},
		{22.916698455811,-1500.9686279297,39.329730987549},
		{17.831211090088,-1494.2575683594,37.992450714111},
		{7.1395072937012,-1509.5537109375,42.928798675537},
		{10.162185668945,-1512.0922851563,40.002593994141},
		{16.313892364502,-1492.2760009766,37.616367340088}
	},

	-- Coord Dinner Dino (Dinosauro Rosa)

	{
		{2571.4816894531,2570.0285644531,46.951427459717},
		{2572.9189453125,2571.6540527344,44.09183883667},
		{2568.5920410156,2573.6887207031,37.081798553467},
		{2561.7690429688,2590.9465332031,38.080516815186},
		{2557.9711914063,2601.4821777344,39.965576171875},
		{2559.9838867188,2595.9379882813,38.08763885498},
		{2563.8229980469,2585.3139648438,42.910820007324},
		{2558.9914550781,2598.9865722656,42.910831451416},
		{2551.0717773438,2608.7976074219,42.910831451416},
		{2556.005859375,2578.7915039063,38.798007965088},
		{2563.8347167969,2586.0151367188,38.083106994629}
	},

	-- Coord Bishop's chicken

	{
		{2581.2775878906,464.97946166992,108.62802886963},
		{2586.8488769531,464.7939453125,109.57823944092},
		{2575.4028320313,464.84127807617,109.60405731201},
		{2575.0324707031,465.26657104492,114.93048095703},
		{2578.9033203125,462.55291748047,116.45458221436},
		{2583.18359375,462.80606079102,116.35272216797},
		{2589.556640625,465.9501953125,114.92737579346},
		{2572.2465820313,480.04525756836,108.67746734619},
		{2572.0187988281,483.87170410156,110.10795593262},
		{2589.6025390625,483.10382080078,108.67394256592},
		{2583.880859375,464.56091308594,108.6205368042}
	},

	-- Coord Restaurante Japones

	{
		{-640.56127929688,-1249.5802001953,11.810453414917},
		{-637.49475097656,-1249.9981689453,11.810453414917},
		{-648.97430419922,-1246.6809082031,17.291667938232},
		{-651.72918701172,-1241.8990478516,17.332021713257},
		{-643.74310302734,-1249.2303466797,19.53212928772},
		{-633.91680908203,-1250.8958740234,19.254760742188},
		{-630.30865478516,-1251.0531005859,17.361194610596},
		{-626.37377929688,-1247.2805175781,17.402637481689},
		{-632.66485595703,-1252.5845947266,11.093974113464},
		{-646.69598388672,-1250.7189941406,10.884791374207},
		{-639.1044921875,-1250.9847412109,19.102352142334}
	},

	-- Coord Universidade
	
	{
		{-1637.0148925781,180.4079284668,61.757274627686},
		{-1636.0783691406,182.31719970703,68.904052734375},
		{-1636.0783691406,182.31723022461,68.90404510498},
		{-1635.1993408203,179.86029052734,68.871589660645},
		{-1635.6630859375,177.37167358398,69.555793762207},
		{-1637.1378173828,180.4545135498,69.555717468262},
		{-1638.1145019531,183.36039733887,69.555709838867},
		{-1632.3325195313,174.4873046875,67.239791870117},
		{-1638.5227050781,187.48635864258,67.239601135254},
		{-1637.3295898438,184.58584594727,61.757278442383},
		{-1634.3095703125,177.70878601074,61.757312774658}
	},

	-- Coord Central eletrica (norte)

	{
		{2057.4450683594,3691.7973632813,37.874008178711},
		{2060.8330078125,3686.1147460938,37.874042510986},
		{2056.3049316406,3685.1215820313,37.376705169678},
		{2054.4521484375,3688.5607910156,37.37670135498},
		{2051.7827148438,3687.1247558594,37.37674331665},
		{2053.6752929688,3683.4758300781,37.376697540283},
		{2039.6079101563,3676.3334960938,37.180187225342},
		{2038.52734375,3678.9709472656,37.361518859863},
		{2047.7624511719,3678.525390625,37.874004364014},
		{2045.1937255859,3683.7351074219,37.874004364014},
		{2052.7619628906,3688.71484375,34.587978363037}
	},

	-- Coord Casa 4

	{
		{-932.96563720703,-942.27453613281,7.0284061431885},
		{-932.34838867188,-940.07568359375,7.0284061431885},
		{-934.03564453125,-937.85925292969,7.0284061431885},
		{-935.076171875,-935.39093017578,7.0284061431885},
		{-936.40545654297,-935.64166259766,11.752877235413},
		{-933.15405273438,-940.95751953125,11.802448272705},
		{-934.82592773438,-939.84674072266,2.1453113555908},
		{-935.98425292969,-937.46838378906,2.1453106403351},
		{-935.48449707031,-944.75628662109,2.1453099250793},
		{-938.50286865234,-935.58221435547,2.1453123092651},
		{-933.46911621094,-942.24267578125,2.1453123092651}
	}
}