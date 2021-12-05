'use-strict';

const { createStringReplacerDomain } = require('./domain');

function validateEvent(event) {
    if (!event.inputString) {
        throw new Error('Input String not present');
    }
}

class StringReplacerInterface {
    constructor(configuration, dependencies) {
        this.configuration = configuration;
        this.dependencies = dependencies;
        this.stringReplacerDomain = dependencies.stringReplacerDomain;
    }

    replaceString(event) {
        try {
            validateEvent(event);
            const { inputString } = event;
            const replacedString = this.stringReplacerDomain.replaceString(inputString);

            return {
                statusCode: 200,
                body: JSON.stringify(replacedString)
            };
        } catch (err) {
            console.log('Encountered Error: ', err.message);
            return {
                statusCode: 400,
                body: JSON.stringify(err.message)
            };
        }

    }
}

function createConfiguration() {
    const configuration = {};
    return configuration;
}

function createDependencies(configuration) {
    const dependencies = {};
    dependencies.stringReplacerDomain = createStringReplacerDomain(configuration);
    return dependencies;
}

function createApplication() {
    const configuration = createConfiguration();
    const dependencies = createDependencies(configuration);

    return new StringReplacerInterface(configuration, dependencies);
}

module.exports.replaceString = async function (event) {
    const applicationObject = createApplication();
    return await applicationObject.replaceString(JSON.parse(event.body));
}

module.exports.StringReplacerInterface = StringReplacerInterface;