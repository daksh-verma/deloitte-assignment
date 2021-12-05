'use strict';

const Assert = require('assert');
const { replaceString, StringReplacerInterface } = require('../../src/user-interface');

let moduleUnderTest;
const expectedInputString = 'This is a test string';

beforeEach(() => {
    const dummyConfiguration = {};
    const stringReplacerDomainStub = {
        replaceString: function (inputString) {
            Assert.deepStrictEqual(inputString, expectedInputString);
            return `${inputString}`;
        }
    };

    const dummyDependencies = {
        stringReplacerDomain: stringReplacerDomainStub
    }
    moduleUnderTest = new StringReplacerInterface(dummyConfiguration, dummyDependencies);
});

describe('User Interface Test Cases', () => {
    it('should replace string', () => {
        const dummyEvent = { inputString: expectedInputString }
        const expectedResponse = {
            statusCode: 200,
            body: JSON.stringify(expectedInputString)
        };

        const actualResponse = moduleUnderTest.replaceString(dummyEvent);
        Assert.deepStrictEqual(actualResponse, expectedResponse);
    });
});