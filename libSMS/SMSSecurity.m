/*
 SMSSecurity.m
 
 Copyright (c) 2010, Alex Silverman
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 3. Neither the name of Alex Silverman nor the
 names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "SMSSecurity.h"

SecKeyRef SMSSecurityPublicKeyRefForCert(CFDataRef certData)
{
	SecCertificateRef certRef = SecCertificateCreateWithData(NULL, certData);
	
	SecTrustRef trustRef = NULL;
	OSStatus status = SecTrustCreateWithCertificates((CFArrayRef)[NSArray arrayWithObject:(id)certRef], SecPolicyCreateBasicX509(), &trustRef);
	CFRelease(certRef);
	
	if (status != noErr) {
		NSLog(@"SMSSecurity: problem creating trust from certificate, OSStatus = %lu", status);
		return NULL;
	}
	
	SecTrustResultType result;
	status = SecTrustEvaluate(trustRef, &result);

	if (status != noErr) {
		NSLog(@"SMSSecurity: trust evaluation failed, OSStatus = %lu, result = %lu", status, result);
		return NULL;
	}
	
	SecKeyRef publicKey = SecTrustCopyPublicKey(trustRef);
	return publicKey;
}