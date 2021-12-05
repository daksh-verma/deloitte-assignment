'use strict';

const Assert = require('assert');
const { create } = require('domain');
const { createStringReplacerDomain } = require('../../src/domain');

let moduleUnderTest;
const expectedInputString = 'Google Amazon Oracle Microsoft Deloitte Google Amazon Oracle Microsoft Deloitte';

beforeEach(() => {
    const dummyConfiguration = {};
    moduleUnderTest = new createStringReplacerDomain(dummyConfiguration);
});

describe('Domain Test Cases', () => {
    it('should replace string', () => {
        const expectedResponse = {
            replacedString: 'Google© Amazon© Oracle© Microsoft© Deloitte© Google© Amazon© Oracle© Microsoft© Deloitte©'
        }

        const actualResponse = moduleUnderTest.replaceString(expectedInputString);
        Assert.deepStrictEqual(actualResponse, expectedResponse);
    });
});