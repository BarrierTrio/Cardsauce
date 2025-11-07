ArrowAPI.credits = {
    --- Table containing display names for all mod contributors, indexed by shortened key
    ArrowAPI = {
        ['gote'] = "BarrierTrio/Gote",
        ['keku'] = "Keku",
        ['cejai'] = "SagaciousCejai",
        ['eremel'] = "Eremel",
        ['yunkie'] = "yunkie101",
        ['joey'] = "Joey",
        ['winter'] = "TheWinterComet"
    },

    add_credits = function(mod, args)
        ArrowAPI['credits'][mod.id] = args
    end
}