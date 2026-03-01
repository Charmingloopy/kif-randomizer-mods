
begin
    mod_debug_path = "ModsDebug.txt"
    File.open(mod_debug_path, "a") do |f|
        f.puts("[#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}] Ability Randomizer loaded successfully")
    end
rescue
    # Silently fail if we can't write to debug file during early initialization
end
class PokemonGlobalMetadata
    attr_accessor :randomize_abilities


    alias __abilities_initialize initialize
    def initialize
        __abilities_initialize
        @randomize_abilities = false

    end
end
module ModifyPokemonData
    LOOPY_ABILITY_LIST  = [:STENCH, :DRIZZLE, :SPEEDBOOST, :BATTLEARMOR, :STURDY, :DAMP, :LIMBER, :SANDVEIL, :STATIC, :VOLTABSORB, :WATERABSORB, :OBLIVIOUS, :CLOUDNINE, :COMPOUNDEYES, :INSOMNIA, :COLORCHANGE, :IMMUNITY, :FLASHFIRE, :SHIELDDUST, :OWNTEMPO, :SUCTIONCUPS, :INTIMIDATE, :SHADOWTAG, :ROUGHSKIN, :WONDERGUARD, :LEVITATE, :EFFECTSPORE, :SYNCHRONIZE, :CLEARBODY, :NATURALCURE, :LIGHTNINGROD, :SERENEGRACE, :SWIFTSWIM, :CHLOROPHYLL, :ILLUMINATE, :TRACE, :HUGEPOWER, :POISONPOINT, :INNERFOCUS, :MAGMAARMOR, :WATERVEIL, :MAGNETPULL, :SOUNDPROOF, :RAINDISH, :SANDSTREAM, :PRESSURE, :THICKFAT, :EARLYBIRD, :FLAMEBODY, :RUNAWAY, :KEENEYE, :HYPERCUTTER, :PICKUP, :TRUANT, :HUSTLE, :CUTECHARM, :PLUS, :MINUS, :FORECAST, :STICKYHOLD, :SHEDSKIN, :GUTS, :MARVELSCALE, :LIQUIDOOZE, :OVERGROW, :BLAZE, :TORRENT, :SWARM, :ROCKHEAD, :DROUGHT, :ARENATRAP, :VITALSPIRIT, :WHITESMOKE, :PUREPOWER, :SHELLARMOR, :AIRLOCK, :TANGLEDFEET, :MOTORDRIVE, :RIVALRY, :STEADFAST, :SNOWCLOAK, :GLUTTONY, :ANGERPOINT, :UNBURDEN, :HEATPROOF, :SIMPLE, :DRYSKIN, :DOWNLOAD, :IRONFIST, :POISONHEAL, :ADAPTABILITY, :SKILLLINK, :HYDRATION, :SOLARPOWER, :QUICKFEET, :NORMALIZE, :SNIPER, :MAGICGUARD, :NOGUARD, :STALL, :TECHNICIAN, :LEAFGUARD, :KLUTZ, :MOLDBREAKER, :SUPERLUCK, :AFTERMATH, :ANTICIPATION, :FOREWARN, :UNAWARE, :TINTEDLENS, :FILTER, :SLOWSTART, :SCRAPPY, :STORMDRAIN, :ICEBODY, :SOLIDROCK, :SNOWWARNING, :HONEYGATHER, :FRISK, :RECKLESS, :MULTITYPE, :FLOWERGIFT, :BADDREAMS, :PICKPOCKET, :SHEERFORCE, :CONTRARY, :UNNERVE, :DEFIANT, :DEFEATIST, :CURSEDBODY, :HEALER, :FRIENDGUARD, :WEAKARMOR, :HEAVYMETAL, :LIGHTMETAL, :MULTISCALE, :TOXICBOOST, :FLAREBOOST, :HARVEST, :TELEPATHY, :MOODY, :OVERCOAT, :POISONTOUCH, :REGENERATOR, :BIGPECKS, :SANDRUSH, :WONDERSKIN, :ANALYTIC, :ILLUSION, :IMPOSTER, :INFILTRATOR, :MUMMY, :MOXIE, :JUSTIFIED, :RATTLED, :MAGICBOUNCE, :SAPSIPPER, :PRANKSTER, :SANDFORCE, :IRONBARBS, :ZENMODE, :VICTORYSTAR, :TURBOBLAZE, :TERAVOLT, :AROMAVEIL, :FLOWERVEIL, :CHEEKPOUCH, :PROTEAN, :FURCOAT, :MAGICIAN, :BULLETPROOF, :COMPETITIVE, :STRONGJAW, :REFRIGERATE, :SWEETVEIL, :STANCECHANGE, :GALEWINGS, :MEGALAUNCHER, :GRASSPELT, :SYMBIOSIS, :TOUGHCLAWS, :PIXILATE, :GOOEY, :AERILATE, :PARENTALBOND, :DARKAURA, :FAIRYAURA, :AURABREAK, :PRIMORDIALSEA, :DESOLATELAND, :DELTASTREAM, :STAMINA, :WIMPOUT, :EMERGENCYEXIT, :WATERCOMPACTION, :MERCILESS, :SHIELDSDOWN, :STAKEOUT, :WATERBUBBLE, :STEELWORKER, :BERSERK, :SLUSHRUSH, :LONGREACH, :LIQUIDVOICE, :TRIAGE, :GALVANIZE, :SURGESURFER, :SCHOOLING, :DISGUISE, :BATTLEBOND, :POWERCONSTRUCT, :CORROSION, :COMATOSE, :QUEENLYMAJESTY, :INNARDSOUT, :DANCER, :BATTERY, :FLUFFY, :DAZZLING, :SOULHEART, :TANGLINGHAIR, :RECEIVER, :POWEROFALCHEMY, :BEASTBOOST, :RKSSYSTEM, :ELECTRICSURGE, :PSYCHICSURGE, :MISTYSURGE, :GRASSYSURGE, :FULLMETALBODY, :SHADOWSHIELD, :PRISMARMOR, :NEUROFORCE]
if defined?(ModSettingsMenu)
    ModSettingsMenu.register(:randomize_abilities, {
                                           name: "Randomize Abilities",
                                           type: :button,
                                           description: "Randomizes abilities",
                                           on_press: proc {
                                                           ModifyPokemonData::shuffle_abilities()
                                                          },
                                           category: "Debug & Developer",
                                           searchable: ["reset", "clear", "default"]
                                          })

end

@Loopy_Rand_abilities = nil

# saves the random abilities
SaveData.register(:loopy_rand_ability) do


    optional
    ensure_class :Array
    echoln ModifyPokemonData::LOOPY_ABILITY_LIST
    abi = ModifyPokemonData::LOOPY_ABILITY_LIST.clone
    @Loopy_Rand_abilities = abi
    ModifyPokemonData::load_poke_data()
    save_value { @Loopy_Rand_abilities }
    load_value { |value|
                 if value == nil or value == []
               value = abi.clone

               end



               # Iterate through the array and pass each data hash
               # This part is important, it asks KIF to modify the data of the Pokémons!
               if $PokemonGlobal.randomize_abilities == true
               @Loopy_Rand_abilities = value
               ModifyPokemonData::load_poke_data()
               end


               }


    new_game_value {abi}
end


def self.shuffle_abilities()
    @Loopy_Rand_abilities = ModifyPokemonData::LOOPY_ABILITY_LIST.clone
    @Loopy_Rand_abilities.shuffle!
    ModifyPokemonData::load_poke_data()
    $PokemonGlobal.randomize_abilities = true
    pbMessage("Randomized Abilities!")

end

end
alias ability_passmoddedpokemon passModdedPokemon
def passModdedPokemon(data={})

    # check if data isn't empty

    if !data.empty?
        # check that data is a hash/dict
        ability_onenum = 0
        ability_2num = 0
        abi = -1
        hid = -1

        if @Loopy_Rand_abilities == nil or @Loopy_Rand_abilities = []
            @Loopy_Rand_abilities = ModifyPokemonData::LOOPY_ABILITY_LIST.clone
        end
        if @Loopy_Rand_abilities == ModifyPokemonData::LOOPY_ABILITY_LIST
            @Loopy_Rand_abilities.shuffle!
        end

        if data.is_a?(Hash)
            data[:abilities].each_with_index do |i_value, i|
                ModifyPokemonData::LOOPY_ABILITY_LIST.each_with_index do |n_value, n|

                    if data[:abilities][i] == ModifyPokemonData::LOOPY_ABILITY_LIST[n]
                        ability_onenum = n
                    end
                end
                data[:abilities][i] = @Loopy_Rand_abilities[ability_onenum]
            end
            data[:hidden_abilities].each_with_index do |i_value, i|
                ModifyPokemonData::LOOPY_ABILITY_LIST.each_with_index do |_value, n|

                    if data[:hidden_abilities][i] == ModifyPokemonData::LOOPY_ABILITY_LIST[n]
                        ability_2num = n
                    end
                end
                data[:hidden_abilities][i] = @Loopy_Rand_abilities[ability_2num]
            end

            ability_passmoddedpokemon(data)
        end
    end
end
