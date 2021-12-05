'use strict';

function importTestModules(moduleLocation) {
    require(`./${moduleLocation}/index.test.js`);
}

importTestModules('user-interface');
importTestModules('domain');