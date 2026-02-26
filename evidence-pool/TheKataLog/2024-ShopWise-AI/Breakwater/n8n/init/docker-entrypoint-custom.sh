#!/bin/sh
n8n import:workflow --separate --input=/init/workflow && n8n import:credentials --separate --input=/init/credentials && n8n
