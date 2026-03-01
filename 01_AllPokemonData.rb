def passModdedPokemon(data={})
    # check if data isn't empty
    if !data.empty?
        # check that data is a hash/dict
        if data.is_a?(Hash)
            $POKEMONDATA_QUEUEING.push(data)
        end
    end
end

def export_data(list)
    # Open file in the main project folder
    File.open("pokemon_data_export.txt", "w") do |f|

        list.each do | species|
             f.write("{\n")
            species.each do |key, value|

                f.write("  :#{key} => #{value.inspect},\n")
            end

            f.write("},\n")
        end
    end
end
def get_base_data()
    list = []
end
def get_species_list()
    list = []
    GameData::Species.each do |species|
        spec = {
            :id                     => species.id,
            :id_number              => species.id_number,
            :name                   => species.real_name,
            :form_name              => species.real_form_name,
            :category               => species.real_category,
            :pokedex_entry          => species.real_pokedex_entry,
            :type1                  => species.type1,
            :type2                  => species.type2,
            :base_stats             => species.base_stats,
            :evs                    => species.evs,
            :base_exp               => species.base_exp,
            :growth_rate            => species.growth_rate,
            :gender_ratio           => species.gender_ratio,
            :catch_rate             => species.catch_rate,
            :happiness              => species.happiness,
            :moves                  => species.moves,
            :tutor_moves            => species.tutor_moves,
            :egg_moves              => species.egg_moves,
            :abilities              => species.abilities,
            :hidden_abilities       => species.hidden_abilities,
            :wild_item_common       => species.wild_item_common,
            :wild_item_uncommon     => species.wild_item_uncommon,
            :wild_item_rare         => species.wild_item_rare,
            :egg_groups             => species.egg_groups,
            :hatch_steps            => species.hatch_steps,
            :evolutions             => species.evolutions,
            :height                 => species.height,
            :weight                 => species.weight,
            :color                  => species.color,
            :shape                  => species.shape,
            :habitat                => species.habitat,
            :generation             => species.generation,
            :back_sprite_x          => species.back_sprite_x,
            :back_sprite_y          => species.back_sprite_y,
            :front_sprite_x         => species.front_sprite_x,
            :front_sprite_y         => species.front_sprite_y,
            :front_sprite_altitude  => species.front_sprite_altitude,
            :shadow_x               => species.shadow_x,
            :shadow_size            => species.shadow_size
            }

        list << spec
    end
export_data(list)
return list
end

module ModifyPokemonData
    @pokemon_data = get_species_list()


    def self.load_poke_data()

        poke_data = get_species_list()
        poke_data.each do |data|

            passModdedPokemon(data)
        end
        GameData::kuray_modqueue()

    end
    # Iterate through the array and pass each data hash
    # This part is important, it asks KIF to modify the data of the Pokémons!

end


