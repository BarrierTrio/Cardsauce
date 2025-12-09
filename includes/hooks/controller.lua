local ref_controller_key = Controller.key_press_update
function Controller:key_press_update(key, dt)
    local ret = ref_controller_key(self, key, dt)

    if Cardsauce.config['enable_EasterEggs'] then
        if key == Cardsauce.mgt[Cardsauce.mgt_num] then
            if key == "o" then
                G.debug_background_toggle = not G.debug_background_toggle
                Cardsauce.mgt_num = 1
            else
                Cardsauce.mgt_num = Cardsauce.mgt_num + 1
            end
        else
            Cardsauce.mgt_num = 1
        end
    end

end