/* 	Copyright (C) Voltic Labs, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

var AWS = require('aws-sdk');
var documentClient = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event, context, callback) => {
	console.log("Hey! COGNITIO TRIGGER PRE ran!");
	//event.response = { autoConfirmUser: true }
	return event
}
