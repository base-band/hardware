#!/usr/bin/env node
'use strict';

const fs = require('fs-extra');
const path = require('path');

const fhyper = require('elastic-circuit/lib/fhyper');
const fhyperDot = require('elastic-circuit/lib/fhyper-dot');
const fhyperV = require('elastic-circuit/lib/fhyper-verilog');
const fhyperManifest = require('elastic-circuit/lib/fhyper-manifest');
const macros = require('../lib/datapath-macros');

const g = fhyper('project');

const dut = g('defunnel');

const r = width => ({width: width, capacity: 1});

g()(r(128))(dut);
g()(r(128))(dut);
g('cfg')(r(8))(dut, 'cfg');
dut(r(512))(g());

const oPath = path.resolve(__dirname, '..', 'test', 'defunnel');
fs.outputFile(path.resolve(oPath, 'project.dot'), fhyperDot(g), () => {
    fs.outputFile(path.resolve(oPath, 'project.v'), fhyperV(g, macros), () => {
        fs.outputFile(path.resolve(oPath, 'project.js'), fhyperManifest(g, 'project'), () => {});
    });
});
