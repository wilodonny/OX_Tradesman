Config = Config or {}

Config.PedProps = {
    ['location'] = 
		vector4(-266.25, -955.49, 31.23, 130.21), -- ALTA STREET OFFICE (CHANGE TO YOUR PREFFERED LOCATION)
    ['hash'] = `u_m_o_taphillbilly`
}

Config.Blip = {
    coords = vector3(-266.25, -955.49, 31.23),  -- ALTA STREET OFFICE (CHANGE TO YOUR PREFFERED LOCATION)
    name = "Test Sell Ped",
    icon = 208,  
    color = 5,
    size = 1.0,
    blipVisible = false 
}

Config.Items = {
    ['burger'] = { 
        label = "Burger", 
        price = 10 
    },
    ['lockpick'] = {
        label = "Lockpick", 
        price = 50
    },

    ['radio'] = {
        label = "Radio", 
        price = 100
    },

-- ADD MORE ITEMS HERE 

-- EXAMPLE
--   ['ITEM NAME'] = {
--       label = "ITEM LABEL", 
--       price = SELL PRICE
--   },

}


