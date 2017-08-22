require 'sketchup.rb'

module Deciducraft
    module Gouge3D
        # This class is responsible for prompting the user for their parameters as well as holding any other global constants
        class Parameters
            # constants
            attr_reader :fluteParabolaSides
            attr_reader :wingProfileArcSides
            attr_reader :gougeLength
            
            # user options
            attr_reader :rodDiameter
            attr_reader :fluteWidth
            attr_reader :thicknessBottom
            attr_reader :wingProfileRadius
            attr_reader :wingLength

            # operation result
            attr_reader :cancelled

            def initialize
                
                @fluteParabolaSides = 40
                @wingProfileArcSides = 40
                @gougeLength = 8.0

                prompts = [
                    "Gouge rod diameter",
                    "Flute width",
                    "Thickness of gouge bottom",
                    "Radius of wing profile",
                    "Wing length!"
                ]
                defaults = [
                    0.625,
                    0.375,
                    0.125,
                    1.5,
                    1
                ]
                puts "Prompting for options.."
                input = UI.inputbox(prompts, defaults, "Enter Gouge Parameters")
                
                unless input
                    puts "User cancelled."
                    @cancelled = true
                else
                    puts "User picked options."
                    @cancelled = false
                    @rodDiameter = input[0].to_f
                    @fluteWidth = input[1].to_f
                    @thicknessBottom = input[2].to_f
                    @wingProfileRadius = input[3].to_f
                    @wingLength = input[4].to_f
                end
            end
        end
    end
end