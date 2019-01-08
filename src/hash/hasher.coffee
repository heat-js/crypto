
export default class Hasher

	constructor: (@processors) ->

	get: (version) ->
		return @processors[version - 1].slice()

	parse: (hash) ->
		[ version, hash ] = String hash
			.split '@'

		version = parseInt version, 10
		return {
			version: version or 1
			hash
		}

	needsUpgrade: (hash) ->
		{ version } = @parse hash
		return @processors.length isnt version

	compare: (payload, hash, passphrase) ->
		{ version, hash } 	= @parse hash
		processors			= @get version
		length 				= processors.length - 1

		for processor, index in processors
			if length is index and processor.compare
				return processor.compare payload, hash, passphrase
			else
				payload = processor.hash payload, passphrase

		return payload is hash

	hash: (payload, passphrase, version = @processors.length) ->
		for processor in @get version
			payload = processor.hash payload, passphrase

		return [ version, payload ].join '@'
