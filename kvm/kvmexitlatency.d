#!/usr/sbin/dtrace -s

/*
 * This D file provides translation from all of the reasons we return from the
 * VMRUN/VMRESUME instruction. This is meant to be similar to
 * /usr/lib/dtrace/errno.d
 */

#pragma D option quiet

inline int EXIT_REASON_EXCEPTION_NMI = 0;
inline int EXIT_REASON_EXTERNAL_INTERRUPT = 1;
inline int EXIT_REASON_TRIPLE_FAULT = 2;

inline int EXIT_REASON_PENDING_INTERRUPT = 7;
inline int EXIT_REASON_NMI_WINDOW = 8;
inline int EXIT_REASON_TASK_SWITCH = 9;
inline int EXIT_REASON_CPUID = 10;
inline int EXIT_REASON_HLT = 12;
inline int EXIT_REASON_INVLPG = 14;
inline int EXIT_REASON_RDPMC = 15;
inline int EXIT_REASON_RDTSC = 16;
inline int EXIT_REASON_VMCALL = 18;
inline int EXIT_REASON_VMCLEAR = 19;
inline int EXIT_REASON_VMLAUNCH = 20;
inline int EXIT_REASON_VMPTRLD = 21;
inline int EXIT_REASON_VMPTRST = 22;
inline int EXIT_REASON_VMREAD = 23;
inline int EXIT_REASON_VMRESUME = 24;
inline int EXIT_REASON_VMWRITE = 25;
inline int EXIT_REASON_VMOFF = 26;
inline int EXIT_REASON_VMON = 27;
inline int EXIT_REASON_CR_ACCESS = 28;
inline int EXIT_REASON_DR_ACCESS = 29;
inline int EXIT_REASON_IO_INSTRUCTION = 30;
inline int EXIT_REASON_MSR_READ = 31;
inline int EXIT_REASON_MSR_WRITE = 32;
inline int EXIT_REASON_MWAIT_INSTRUCTION = 36;
inline int EXIT_REASON_MONITOR_INSTRUCTION = 39;
inline int EXIT_REASON_PAUSE_INSTRUCTION = 40;
inline int EXIT_REASON_MCE_DURING_VMENTRY = 41;
inline int EXIT_REASON_TPR_BELOW_THRESHOLD = 43;
inline int EXIT_REASON_APIC_ACCESS = 44;
inline int EXIT_REASON_EPT_VIOLATION = 48;
inline int EXIT_REASON_EPT_MISCONFIG = 49;
inline int EXIT_REASON_WBINVD = 54;


inline string strexitno[int32_t r] = 
    r == EXIT_REASON_EXCEPTION_NMI ? "EXIT_REASON_EXCEPTION_NMI" :
    r == EXIT_REASON_EXTERNAL_INTERRUPT ? "EXIT_REASON_EXTERNAL_INTERRUPT" :
    r == EXIT_REASON_TRIPLE_FAULT ? "EXIT_REASON_TRIPLE_FAULT" :
    r == EXIT_REASON_PENDING_INTERRUPT ? "EXIT_REASON_PENDING_INTERRUPT" :
    r == EXIT_REASON_NMI_WINDOW ? "EXIT_REASON_NMI_WINDOW" :
    r == EXIT_REASON_TASK_SWITCH ? "EXIT_REASON_TASK_SWITCH" :
    r == EXIT_REASON_CPUID ? "EXIT_REASON_CPUID" :
    r == EXIT_REASON_HLT ? "EXIT_REASON_HLT" :
    r == EXIT_REASON_INVLPG ? "EXIT_REASON_INVLPG" :
    r == EXIT_REASON_RDPMC ? "EXIT_REASON_RDPMC" :
    r == EXIT_REASON_RDTSC ? "EXIT_REASON_RDTSC" :
    r == EXIT_REASON_VMCALL ? "EXIT_REASON_VMCALL" :
    r == EXIT_REASON_VMCLEAR ? "EXIT_REASON_VMCLEAR" :
    r == EXIT_REASON_VMLAUNCH ? "EXIT_REASON_VMLAUNCH" :
    r == EXIT_REASON_VMPTRLD ? "EXIT_REASON_VMPTRLD" :
    r == EXIT_REASON_VMPTRST ? "EXIT_REASON_VMPTRST" :
    r == EXIT_REASON_VMREAD ? "EXIT_REASON_VMREAD" :
    r == EXIT_REASON_VMRESUME ? "EXIT_REASON_VMRESUME" :
    r == EXIT_REASON_VMWRITE ? "EXIT_REASON_VMWRITE" :
    r == EXIT_REASON_VMOFF ? "EXIT_REASON_VMOFF" :
    r == EXIT_REASON_VMON ? "EXIT_REASON_VMON" :
    r == EXIT_REASON_CR_ACCESS ? "EXIT_REASON_CR_ACCESS" :
    r == EXIT_REASON_DR_ACCESS ? "EXIT_REASON_DR_ACCESS" :
    r == EXIT_REASON_IO_INSTRUCTION ? "EXIT_REASON_IO_INSTRUCTION" :
    r == EXIT_REASON_MSR_READ ? "EXIT_REASON_MSR_READ" :
    r == EXIT_REASON_MSR_WRITE ? "EXIT_REASON_MSR_WRITE" :
    r == EXIT_REASON_MWAIT_INSTRUCTION ? "EXIT_REASON_MWAIT_INSTRUCTION" :
    r == EXIT_REASON_MONITOR_INSTRUCTION ? "EXIT_REASON_MONITOR_INSTRUCTION" :
    r == EXIT_REASON_PAUSE_INSTRUCTION ? "EXIT_REASON_PAUSE_INSTRUCTION" :
    r == EXIT_REASON_MCE_DURING_VMENTRY ? "EXIT_REASON_MCE_DURING_VMENTRY" :
    r == EXIT_REASON_TPR_BELOW_THRESHOLD ? "EXIT_REASON_TPR_BELOW_THRESHOLD" :
    r == EXIT_REASON_APIC_ACCESS ? "EXIT_REASON_APIC_ACCESS" :
    r == EXIT_REASON_EPT_VIOLATION ? "EXIT_REASON_EPT_VIOLATION" :
    r == EXIT_REASON_EPT_MISCONFIG ? "EXIT_REASON_EPT_MISCONFIG" :
    r == EXIT_REASON_WBINVD ? "EXIT_REASON_WBINVD" :
    "<unknown>";

dtrace:::BEGIN
{
	trace("Tracing KVM exits (ns)... Hit Ctrl-C to stop\n");
}

sdt:::kvm-vexit
{
	self->reason = arg1;
	self->start = timestamp;
}

kvm-vcpu-run
/self->start/
{
	@[strexitno[self->reason]] = quantize(timestamp - self->start);
	self->start = 0;
	self->reason = 0;
}
