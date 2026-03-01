
begin
    mod_debug_path = "ModsDebug.txt"
    File.open(mod_debug_path, "a") do |f|
        f.puts("[#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}] Type Randomizer loaded successfully")
    end
rescue
    # Silently fail if we can't write to debug file during early initialization
end

class PokemonGlobalMetadata
    attr_accessor :randomize_types


    alias __types_initialize initialize
    def initialize
        __types_initialize
        @randomize_types = false

    end
end
module ModifyPokemonData
    LOOPY_TYPE_LIST  = [ :FIRE, :WATER, :GRASS, :ROCK, :GROUND, :ICE, :BUG, :ELECTRIC, :PSYCHIC,:DARK,:FAIRY,:DRAGON,:GHOST,:FIGHTING,:FLYING,:NORMAL,:STEEL,:POISON]
if defined?(ModSettingsMenu)
    ModSettingsMenu.register(:randomize_types, {
                                           name: "Randomize Types",
                                           type: :button,
                                           description: "Randomizes Types",
                                           on_press: proc {
                                                           ModifyPokemonData::shuffle_types()
                                                          },
                                           category: "Difficulty",
                                           searchable: ["randomizer"]
                                          })

end

@Loopy_Rand_types = nil

# saves the random abilities
SaveData.register(:loopy_rand_type) do


    optional
    ensure_class :Array

    types = ModifyPokemonData::LOOPY_TYPE_LIST.clone
    @Loopy_Rand_types = types
     ModifyPokemonData::load_poke_data()
    save_value { @Loopy_Rand_types }
    load_value { |value|
                 if value == nil or value == []
               value = types.clone

               end

               # Iterate through the array and pass each data hash
               # This part is important, it asks KIF to modify the data of the Pokémons!
               if $PokemonGlobal.randomize_types == true

                   @Loopy_Rand_types = value

                   ModifyPokemonData::load_poke_data()
               end


               }

    new_game_value {types}
end


def self.shuffle_types()
    @Loopy_Rand_types = ModifyPokemonData::LOOPY_TYPE_LIST.clone
    @Loopy_Rand_types.shuffle!
    ModifyPokemonData::load_poke_data()
    pbMessage("Randomized Types!")
    $PokemonGlobal.randomize_types = true

end

end
alias type_passmoddedpokemon passModdedPokemon
def passModdedPokemon(data={})

    # check if data isn't empty

    if !data.empty?
        # check that data is a hash/dict
        ability_onenum = 0
        ability_2num = 0
        abi = -1
        hid = -1

        if @Loopy_Rand_types == nil or @Loopy_Rand_types = []
            @Loopy_Rand_types = ModifyPokemonData::LOOPY_TYPE_LIST.clone
        end
        if @Loopy_Rand_types == ModifyPokemonData::LOOPY_TYPE_LIST
            @Loopy_Rand_types.shuffle!
        end

        if data.is_a?(Hash)

            if data[:type2] != data[:type1]
                data[:type2] = @Loopy_Rand_types.sample
                data[:type1] = @Loopy_Rand_types.sample
                while data[:type2] == data[:type1]
                    data[:type2] = @Loopy_Rand_types.sample
                end

        else
            data[:type1] = @Loopy_Rand_types.sample
            data[:type2] = data[:type1]
            end
            type_passmoddedpokemon(data)
        end
    end
end
