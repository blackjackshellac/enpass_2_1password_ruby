
##
# Enpassfolder contains the items found in each folder object
#
class EnpassFolder
	KEYS=%w/icon parent_uuid title updated_at uuid/
	#
	# "icon": "1008",
	# "parent_uuid": "",
	# "title": "SECURED:AYhLtEWv",
	# "updated_at": 1605370638,
	# "uuid": "0cfaf483-534a-4080-a0b8-62a721a5fc03"
	attr_reader :folder, :icon, :parent_uuid, :title, :updated_at, :uuid
	def initialize(folder)
		@folder = folder
		KEYS.each { |key|
			val=@folder[key]
			instance_variable_set("@#{key}", val)
			@folder.delete(key)
		}
	end

	def empty?
		@folder.empty?
	end
end

##
# EnpassFolders is a container of EnpassFolder objects
#
class EnpassFolders
	attr_reader :folders
	def initialize(foldersArray, logger)
		@logger = logger
		@folders = []
		foldersArray.each { |folder|
			enpass_folder = EnpassFolder.new(folder)
			@logger.warn "Unknown folder keys: #{enpass_folder.folder.keys}" unless enpass_folder.empty?
			@folders << enpass_folder
		}
	end
end
