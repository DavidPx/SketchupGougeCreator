require 'sketchup.rb'
require_relative './constants.rb'
#load 'constants.rb'

module Deciducraft
    module Gouge3D
        model = Sketchup.active_model

        model.active_entities.clear!

        model.start_operation('Create Gouge', true)

        group = model.active_entities.add_group
        group.description = 'My awesome tube'
        entities = group.entities

        # parameters
        d = 0.625 # rod diameter
        f = 0.5 # flute width
        b = 0.125 # thickness at bottom of flute
        
        r = d/2.0
        f2 = f/2.0 # half the flute width
        ft = r - b # flute thicknes
        z = Math.sqrt(r**2 - f2**2)
        h = z + b
        p = f**2 / 16 / h

        # Vertex form: y = a(x-h)^2 + k (https://mathbitsnotebook.com/Algebra1/Quadratics/QDVertexForm.html)
        # k = -ft
        # at x = -f2, y = sqrt(r^2 - f2^2)
        a = (Math.sqrt(r**2 - f2**2) + ft) / f2**2

        x0 = 0
        y0 = 0
        # draw the flute cutout
        for i in 0..Sides
            x1 = i * f / Sides - f2
            y1 = a * x1**2 - ft

            # Only start adding edges after the second point has been calculated
            if (i > 0)
                entities.add_edges([0, x0, y0], [0, x1, y1])
            end

            x0 = x1
            y0 = y1

        end


        # draw the rod
        centerPoint = Geom::Point3d.new(0, 0, 0)
        
        angle = Math.acos(f2/r) # if viewing the gouge end-on, the angle (like on a clock face) at which the flute stops and the round side begins

        vector = Geom::Vector3d.new 1,0,0
        vector3 = vector.normalize! # this is the vector normal to the arc's surface
        vector2 = Geom::Vector3d.new 0,1,0 # this factor defines in what plane the arc will lie
        
        # use a negative ending angle to produce an outer arc
        arcEdges = entities.add_arc centerPoint, vector2, vector3, r, angle, -(Math::PI + angle), 60
        arcEdges.first.find_faces
        arcFace = arcEdges[1].faces.first
        arcFace.pushpull(-GougeLength)
        





        # Remove the profile curve with a U-shaped arc subtracted from the gouge body
        profileGroup = model.active_entities.add_group
        wingRadius = 1.5
        wingLength = 1.0

        fluteDepth = d - b
        s = Math.sqrt(wingLength**2 + fluteDepth**2)

        puts "fluteDepth: #{fluteDepth}"
        puts "s: #{s}"

        angleD = Math.atan(wingLength / fluteDepth)
        angleC = Math.acos(s / wingRadius / 2.0)
        angleB = Math::PI/2.0 - (angleC - angleD)
        angleE = Math::PI/2.0 - angleB
        angleA = Math::PI/2.0 - angleC
        angleF = angleA + angleE
        lengthQ = Math.sin(angleF) * wingRadius
        lengthT = Math.cos(angleF) * wingRadius

        puts "angleD: #{angleD.radians}"
        puts "angleC: #{angleC.radians}"
        puts "angleB: #{angleB.radians}"
        puts "angleE: #{angleE.radians}"
        puts "angleA: #{angleA.radians}"
        puts "angleF: #{angleF.radians}"
        puts "lengthQ: #{lengthQ}"
        puts "lengthT: #{lengthT}"
        puts "r: #{r}"
        puts "b: #{b}"
        puts "r - b: #{r - b}"
        puts "r - b + lengthT: #{r - b + lengthT}"

        profileCenterPoint = Geom::Point3d.new(GougeLength - lengthQ, 0, (r - b + lengthT) * -1.0)
        profileVector = Geom::Vector3d.new 0,1,0
        profileVector3 = profileVector.normalize! # this is the vector normal to the arc's surface
        profileVector2 = Geom::Vector3d.new 1,0,0 # this factor defines in what plane the arc will lie

        profileEdges = profileGroup.entities.add_arc profileCenterPoint, profileVector2, profileVector3, wingRadius, 0, -Math::PI/2.0, 15
        #arcEdges.first.find_face

        # orientationVector = Geom::Vector3d.new(1, 0, 0)
        # orientationVector.length = 1

        # circleEdges = entities.add_circle(centerPoint, orientationVector, d/2.0, 50)
        # circleFace = entities.add_face(circleEdges)
        

        # # intersect the arc and circle
        # tr = Geom::Transformation.new()
        # entities.intersect_with false, tr, entities, tr, true, entities.to_a

        #circleFace.pushpull(8)

        model.commit_operation
    end
end