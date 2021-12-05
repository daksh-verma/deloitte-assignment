'use strict';

const replacementData = require('./replacement-data.json');

function doReplaceString(inputString) {
    let replacedString = inputString.slice();
    Object.keys(replacementData)
        .forEach(replacementString => {
            let replacementRegex = new RegExp(replacementString, 'g');
            replacedString = replacedString.replace(replacementRegex, replacementData[replacementString]);
        });
    return { replacedString };
}

class StringReplacerDomain {
    constructor(configuration, dependencies) {
        this.configuration = configuration;
        this.dependencies = dependencies;
    }

    replaceString(inputString) {
        try {
            return doReplaceString(inputString);
        } catch (err) {
            console.log('Encountered Error', err);
            throw new Error('There was an unknown error while replacing the string', err.message);
        }
    }
}

function createDependencies(configuration) {
    const dependencies = {};
    return dependencies;
}

module.exports.createStringReplacerDomain = function (configuration) {
    const dependencies = createDependencies(configuration);
    return new StringReplacerDomain(configuration, dependencies);
}