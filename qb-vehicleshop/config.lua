Pepe = {}

PepeCustoms = {}

Config = {}

Config.Job = 'cardealer'

Config = {
    Startpoint = {x = -27.65, y = -1104.08, z = 26.42, h = 250.25, d = 0.8},  
	spawnveh = {x = -50.01, y = -1110.38, z = 26.44, h = 71.81, d = 0.8},  
	Holdup = 30 --- in minute cooldown
}

Config.cars = {  ---------------- Which car do they need to sell?
  "taxi",
  "sentinel3",
}

Config.sellveh = {
	[1] = {x = 1710.35, y = 3704.05, z = 34.37, h = 252.47, d = 1.8}, 
	[2] = {x = 2008.6, y = 4986.35, z = 41.32, h = 41.32, d = 1.8}, 
}

Pepe.VehicleShops = {
    {x = -56.71, y = -1096.65, z = 25.44}
}

Pepe.GarageLabel = {
    ["motelgarage"] = "Motel Garage",
    ["sapcounsel"]  = "San Andreas Parking Counsel",
}

Pepe.SpawnPoint = {x = -59.18, y = -1109.71, z = 25.45, h = 68.5}
Pepe.DefaultGarage = "centralgarage"

Pepe.QuickSell = {x = -46.92, y = -1081.66, z = 26.74, h = 252.5, r = 1.0}

Pepe.ShowroomVehicles = {
    [1] = {
        coords = {x = -45.65, y = -1093.66, z = 25.44, h = 69.5},
        defaultVehicle = "adder",
        chosenVehicle = "adder",
        inUse = false,
    },
    [2] = {
        coords = {x = -48.27, y = -1101.86, z = 25.44, h = 294.5},
        defaultVehicle = "schafter2",
        chosenVehicle = "schafter2",
        inUse = false,
    },
    [3] = {
        coords = {x = -39.6, y = -1096.01, z = 25.44, h = 66.5},
        defaultVehicle = "comet2",
        chosenVehicle = "comet2",
        inUse = false,
    },
    [4] = {
        coords = {x = -51.21, y = -1096.77, z = 25.44, h = 254.5},
        defaultVehicle = "vigero",
        chosenVehicle = "vigero",
        inUse = false,
    },
    [5] = {
        coords = {x = -40.18, y = -1104.13, z = 25.44, h = 338.5},
        defaultVehicle = "t20",
        chosenVehicle = "t20",
        inUse = false,
    },
    [6] = {
        coords = {x = -43.31, y = -1099.02, z = 25.44, h = 52.5},
        defaultVehicle = "bati",
        chosenVehicle = "bati",
        inUse = false,
    },
    [7] = {
        coords = {x = -50.66, y = -1093.05, z = 25.44, h = 222.5},
        defaultVehicle = "bati",
        chosenVehicle = "bati",
        inUse = false,
    },
    [8] = {
        coords = {x = -44.28, y = -1102.47, z = 25.44, h = 298.5},
        defaultVehicle = "bati",
        chosenVehicle = "bati",
        inUse = false,
    }
}

Pepe.VehicleMenuCategories = {
    ["sports"]  = {label = "Sports"},
    ["super"]   = {label = "Super"},
    ["sedans"]  = {label = "Sedans"},
    ["coupes"]  = {label = "Coupes"},
    ["suvs"]    = {label = "SUV's"},
    ["offroad"] = {label = "Offroad"},
}

Pepe.Classes = {
    [0] = "compacts",  
    [1] = "sedans",  
    [2] = "suvs",  
    [3] = "coupes",  
    [4] = "muscle",  
    [5] = "sportsclassics ", 
    [6] = "sports",  
    [7] = "super",  
    [8] = "motorcycles",  
    [9] = "offroad", 
    [10] = "industrial",  
    [11] = "utility",  
    [12] = "vans",  
    [13] = "cycles",  
    [14] = "boats",  
    [15] = "helicopters",  
    [16] = "planes",  
    [17] = "service",  
    [18] = "emergency",  
    [19] = "military",  
    [20] = "commercial",  
    [21] = "trains",  
}

Pepe.DefaultBuySpawn = {x = -56.79, y = -1109.85, z = 26.43, h = 71.5}

PepeCustoms.VehicleBuyLocation = {x = -772.82, y = -235.39, z = 37.07, h = 201.5, r = 1.0}
PepeCustoms.ShowroomPositions = {
    [1] = {
        coords = {
            x = -792.46, 
            y = -233.15, 
            z = 36.05, 
            h = 80.0,
        },
        vehicle = "rapide",
        buying = false,
    }, 
    [2] = {
        coords = {
            x = -789.57, 
            y = -237.95, 
            z = 36.05, 
            h = 83.5, 
        }, 
        vehicle = "arv10",
        buying = false,
    }, 
    [3] = {
        coords = {
            x = -786.98, 
            y = -242.74, 
            z = 36.05, 
            h = 74.5,
        },
        vehicle = "m2",
        buying = false,
    }, 
    [4] = {
        coords = {
            x = -783.27, 
            y = -223.07, 
            z = 36.36, 
            h = 138.5,
        },
        vehicle = "x5e53",
        buying = false,
    },
    [5] = {
        coords = {x = -793.74, y = -229.36, z = 36.07, h = 74.5},
        vehicle = "skyline",
        buying = false,
    },
}