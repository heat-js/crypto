import Json			from '../src/hash/processor/json'
import Hashing		from '../src/hash/processor/hashing'
import Hasher		from '../src/hash/hasher'

hasher = new Hasher [
	[
		new Json
		new Hashing 'sha256', 'your-salt'
	]
]
