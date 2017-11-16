#!/usr/sbin/dtrace -s
/*
 * rcapd_stat.d		show rcapd on-CPU rate
 *
 * Simple tool to be left running to watch for correlations.
 *
 * CDDL HEADER START
 *
 * The contents of this file are subject to the terms of the
 * Common Development and Distribution License, Version 1.0 only
 * (the "License").  You may not use this file except in compliance
 * with the License.
 *
 * You can obtain a copy of the license at http://smartos.org/CDDL
 *
 * See the License for the specific language governing permissions
 * and limitations under the License.
 *
 * When distributing Covered Code, include this CDDL HEADER in each
 * file.
 *
 * If applicable, add the following below this CDDL HEADER, with the
 * fields enclosed by brackets "[]" replaced with your own identifying
 * information: Portions Copyright [yyyy] [name of copyright owner]
 *
 * CDDL HEADER END
 *
 * Copyright (c) 2012 Joyent Inc., All rights reserved.
 * Copyright (c) 2012 Brendan Gregg, All rights reserved.
 */

dtrace:::BEGIN
{
	/* workaround to trick printa() into always firing to start with */
	@ = sum(0);
}

profile:::profile-99hz
/execname == "rcapd"/
{
	@ = sum(1);
}

profile:::tick-1s
{
	printa("rcapd CPU samples @99hz: %@d", @);
	clear(@);
}
