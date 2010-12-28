/**
 *
 * Modified code taken from JSONView
 * From: jsonview.js
 * http://code.google.com/p/jsonview/
 * Copyright (c) 2009 Benjamin Hollis
 */

function JSONFormatter() {
}
JSONFormatter.prototype = {
	htmlEncode : function(t) {
		return t != null ? t.toString().replace(/&/g, "&amp;").replace(/"/g, "&quot;").replace(/</g, "&lt;").replace(/>/g, "&gt;") : '';
	},

	decorateWithSpan : function(value, className) {
		return '<span class="' + className + '">' + this.htmlEncode(value) + '</span>';
	},

	// Convert a basic JSON datatype (number, string, boolean, null, object,
	// array) into an HTML fragment.
	valueToHTML : function(value) {
		var valueType = typeof value, output = "";
		if (value == null) {
			output += this.decorateWithSpan('null', 'null');
		} else if (value && value.constructor == Array) {
			output += this.arrayToHTML(value);
		} else if (valueType == 'object') {
			output += this.objectToHTML(value);
		} else if (valueType == 'number') {
			output += this.decorateWithSpan(value, 'num');
		} else if (valueType == 'string') {
			if (/^(http|https):\/\/[^\s]+$/.test(value)) {
				output += this.decorateWithSpan('"', 'string') + '<a href="' + value + '">' + this.htmlEncode(value) + '</a>'
						+ this.decorateWithSpan('"', 'string');
			} else {
				output += this.decorateWithSpan('"' + value + '"', 'string');
			}
		} else if (valueType == 'boolean') {
			output += this.decorateWithSpan(value, 'bool');
		}

		return output;
	},

	// Convert an array into an HTML fragment
	arrayToHTML : function(json) {
		var prop, output = '[<ul class="array collapsible">', hasContents = false;
		for (prop in json) {
			hasContents = true;
			output += '<li>';
			output += this.valueToHTML(json[prop]);
			output += '</li>';
		}
		output += '</ul>]';

		if (!hasContents) {
			output = "[ ]";
		}

		return output;
	},

	// Convert a JSON object to an HTML fragment
	objectToHTML : function(json) {
		var prop, output = '{<ul class="obj collapsible">', hasContents = false;
		for (prop in json) {
			hasContents = true;
			output += '<li>';
			output += '<span class="prop">' + this.htmlEncode(prop) + '</span>: ';
			output += this.valueToHTML(json[prop]);
			output += '</li>';
		}
		output += '</ul>}';

		if (!hasContents) {
			output = "{ }";
		}

		return output;
	},

	// Convert a whole JSON object into a formatted HTML document.
	jsonToHTML : function(json, callback, uri) {
		var output = '';
		output += '<div id="json">';
		output += this.valueToHTML(json);
		output += '</div>';
		return output;
	}
};

function collapse(evt) {
	var ellipsis, collapser = evt.target, target = collapser.parentNode.getElementsByClassName('collapsible')[0];
	if (!target)
		return;

	if (target.style.display == 'none') {
		ellipsis = target.parentNode.getElementsByClassName('ellipsis')[0];
		target.parentNode.removeChild(ellipsis);
		target.style.display = '';
	} else {
		target.style.display = 'none';
		ellipsis = document.createElement('span');
		ellipsis.className = 'ellipsis';
		ellipsis.innerHTML = ' &hellip; ';
		target.parentNode.insertBefore(ellipsis, target);
	}
	collapser.innerHTML = (collapser.innerHTML == '-') ? '+' : '-';
}

function displayObject(JSONObject) {
	if (!JSONObject)
		return;
	document.body.innerHTML = '<link rel="stylesheet" type="text/css" href="json.css">'
			+ new JSONFormatter().jsonToHTML(JSONObject);
	Array.prototype.forEach.call(document.getElementsByClassName('collapsible'), function(childItem) {
		var collapser, item = childItem.parentNode;
		if (item.nodeName == 'LI') {
			collapser = document.createElement('div');
			collapser.className = 'collapser';
			collapser.innerHTML = '-';
			collapser.addEventListener('click', collapse, false);
			item.insertBefore(collapser, item.firstChild);
		}
	});
}

var jsonDiv = document.getElementById("response");
displayObject(JSON.parse(jsonDiv.innerText));