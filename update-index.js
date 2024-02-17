const fs = require('fs');
const eventPayload = require(process.env.GITHUB_EVENT_PATH);
const order = require('./order.json');

const user = eventPayload.sender.login;
const [flavour, size, toppings, count] = Object.values(order);

const amount = parseInt(count.slice(0, 3), 10) || 1;

const content = `1. [@${user}](https://github.com/${user}) orders ${amount} ${size} ${flavour} pizza with ${toppings}\n`;

fs.appendFileSync('README.md', content);