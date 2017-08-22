require 'sketchup.rb'

module Deciducraft
    module Gouge3D
        class Gouge
            def addToModel(model, parameters)
                @model = model
                @parameters = parameters

                @gougeGroup = model.active_entities.add_group
                @gougeEntities = @gougeGroup.entities
        
                # useful values needed by the methods in here
                @r = parameters.rodDiameter/2.0
                @f2 = parameters.fluteWidth/2.0 # half the flute width
                @ft = @r - parameters.thicknessBottom # flute thickness
                
                self.createFluteParabola
                self.createRod
                self.removeNoseProfile
        
            end

            def createFluteParabola
                z = Math.sqrt(@r**2 - @f2**2)
                h = z + @parameters.thicknessBottom
                
                # Vertex form: y = a(x-h)^2 + k (https://mathbitsnotebook.com/Algebra1/Quadratics/QDVertexForm.html)
                # k = -ft
                # at x = -f2, y = sqrt(r^2 - f2^2)
                a = (Math.sqrt(@r**2 - @f2**2) + @ft) / @f2**2
                cutoutPoints = Array.new()
        
                # draw the flute cutout as a parabola.  Use a Curve because it renders more nicely than a series of edges.
                for i in 0..@parameters.fluteParabolaSides
                    x = i * @parameters.fluteWidth / @parameters.fluteParabolaSides - @f2
                    y = a * x**2 - @ft
                    cutoutPoints.push([0, x, y])
                end
        
                @gougeEntities.add_curve(cutoutPoints)
        
            end

            def createRod
                # draw the rod
                centerPoint = Geom::Point3d.new(0, 0, 0)
                
                angle = Math.acos(@f2/@r) # if viewing the gouge end-on, the angle (like on a clock face) at which the flute stops and the round side begins
        
                vector = Geom::Vector3d.new 1,0,0
                vector3 = vector.normalize! # this is the vector normal to the arc's surface
                vector2 = Geom::Vector3d.new 0,1,0 # this factor defines in what plane the arc will lie
                
                # hint: use a negative ending angle to produce an outer arc
                arcEdges = @gougeEntities.add_arc centerPoint, vector2, vector3, @r, angle, -(Math::PI + angle), 60

                # push/pull the new face to create the solid
                arcEdges.first.find_faces
                arcFace = arcEdges[1].faces.first
                arcFace.pushpull(-@parameters.gougeLength)
            end

            def removeNoseProfile
                # Remove the profile curve with a U-shaped arc subtracted from the gouge body
                profileGroup = @model.active_entities.add_group
                wingRadius = @parameters.wingProfileRadius
                wingLength = @parameters.wingLength
        
                fluteDepth = @parameters.rodDiameter - @parameters.thicknessBottom
                s = Math.sqrt(wingLength**2 + fluteDepth**2)
        
                angleD = Math.atan(wingLength / fluteDepth)
                angleC = Math.acos(s / wingRadius / 2.0)
                angleB = Math::PI/2.0 - (angleC - angleD)
                angleE = Math::PI/2.0 - angleB
                angleA = (Math::PI/2.0 - angleC) * 2
                angleF = angleA + angleE
                lengthQ = Math.sin(angleF) * wingRadius
                lengthT = Math.cos(angleF) * wingRadius
        
                profileCenterPoint = Geom::Point3d.new(@parameters.gougeLength - lengthQ, 3, (@r - @parameters.thicknessBottom + lengthT) * -1.0)
                profileVector = Geom::Vector3d.new 0,1,0
                profileVector3 = profileVector.normalize! # this is the vector normal to the arc's surface
                profileVector2 = Geom::Vector3d.new 1,0,0 # this factor defines in what plane the arc will lie
        
                profileEdges = profileGroup.entities.add_arc profileCenterPoint, profileVector2, profileVector3, wingRadius, 0, -Math::PI/2, 40
                
                # offset the arc so that we can begin to make a solid
                outerProfileEdges = profileGroup.entities.add_arc profileCenterPoint, profileVector2, profileVector3, wingRadius + 1, 0, -Math::PI/2, 40
                
                # connect their two ends and find faces to make a plane; then push/pull to make a solid
                profileGroup.entities.add_line profileEdges.first.start.position, outerProfileEdges.first.start.position
                profileGroup.entities.add_line profileEdges.last.end.position, outerProfileEdges.last.end.position
                profileEdges.first.find_faces()
                profileEdges.first.faces.first.pushpull(6)
        
                # subtract our new arc-shape from the gouge
                profileGroup.subtract(@gougeGroup)
            end
        end
    end
end