class Dungeon
	attr_accessor :player

	def initialize(name)
		@player = Player.new(name)
		@rooms = []
	end

	def start(location)
		@player.location = location
		show_current_description
	end

	def go(direction)
		puts "You go #{direction.to_s}"
		@player.location = find_room_in_direction(direction)
		show_current_description
	end

	def show_current_description
		puts find_room_in_dungeon(@player.location).full_description
	end

	def find_room_in_dungeon(ref)
		# returns the room with the corresponding reference
		@rooms.detect{|room| room.reference == ref.to_sym}
	end

	def find_room_in_direction(direction)
		find_room_in_dungeon(@player.location).connections[direction]
	end

	def add_room(ref,name,desc,conn)
		@rooms << Room.new(ref, name, desc, conn)
	end

	class Player
		attr_accessor :name,:location
		def initialize(name)
			@name = name
		end
	end

	class Room
		attr_accessor :reference, :name, :description, :connections

		def initialize(ref, name, desc, conns)
			@reference, @name, @description, @connections = [ref, name, desc, conns]
		end

		def full_description
			"#{name}\n\n#{@description}"
		end
	end

end

dungeon = Dungeon.new("Tit")
dungeon.add_room(:largecave, "Large Cave", "An empty cavernous space. Far below the narrow path is a vast underground ocean, seemingly bottomless.", {west: :smallcave})
dungeon.add_room(:smallcave, "Small Cave", "This is where you woke up, head pounding and with nothing but the clothes on your back. A sickeningly sweet stench erodes the air.", {east: :largecave})
dungeon.start(:smallcave)
dungeon.go(:east)
