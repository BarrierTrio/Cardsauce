--If the current container is being 'Hovered', usually by a cursor, determine if any hover popups need to be generated and do so

if Galdur then
    local ref_node_hover = Node.hover
    function Node:hover(...)
        if self.config and self.params and self.params.deck_select and self.config.center.artist and self.config.h_popup then
            local desc_nodes = self.config.h_popup.nodes[2].nodes[1].nodes
            table.insert(desc_nodes, 3, {
                n = G.UIT.R,
                config = {align = "cm"},
                nodes = {{
                    n = G.UIT.O,
                    config = {
                        object = UIBox{
                            definition = G.UIDEF.deck_credit(self.config.center),
                            config = {offset = {x=0,y=0}}
                        }
                    }
                }}
            })
        end

        return ref_node_hover(self, ...)
    end
end


