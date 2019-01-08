
import crypto from 'crypto'

export default class ManipulationProtection

	constructor: (@algorithm, @salt) ->

	generateKey: (passphrase) ->
		return Buffer.concat [
			Buffer.from @salt, 'utf8'
			Buffer.from passphrase or '', 'utf8'
		]

	encrypt: (payload, passphrase) ->
		key = @generateKey passphrase
		hmac = crypto.createHmac @algorithm, key
		hmac.update payload, 'utf8'
		hash = hmac.digest 'hex'

		return [
			hash
			payload
		].join ':'

	decrypt: (payload, passphrase) ->
		key 		= @generateKey passphrase
		parts 		= payload.split ':'
		hash 		= parts.shift()
		encrypted 	= parts.join ':'

		hmac = crypto.createHmac @algorithm, key
		hmac.update encrypted, 'utf8'
		other = hmac.digest 'hex'

		if other isnt hash
			throw new Error 'Manipulation protection error'

		return encrypted
