Song.find(1).create_activity :release, owner: Song.find(1).user
Song.find(2).create_activity :release, owner: Song.find(1).user
Remix.find(1).create_activity :create, owner: User.find(1) unless Remix.find(1).nil?
User.find(1).create_activity :follow, owner: User.find(2)
User.find(2).create_activity :follow, owner: User.find(1)
Song.find(1).create_activity :like,   owner: User.find(1)
Song.find(2).create_activity :like,   owner: User.find(1)
Song.find(1).create_activity :like,   owner: User.find(2)

