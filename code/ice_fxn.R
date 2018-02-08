source( '~/misc/ICE/ICE.R' )	## downloaded from ICE webiste

ice_summ_fxn<- function(Y, g, ML=FALSE, Ks='null', K.n=1){

	pvals <- array( NA,
		dim=c(3, K.n,	ncol(Y) ), dimnames=list(c('beta','sd','pval'),	Ks,	1:ncol(Y))
	)

	if(!ML){
		pvals[3,1,]	<- -log10( ICE.REMLt.batch(t(Y), matrix(g,nrow=1) )$ps)
	} else {
		pvals[3,1,]	<- -log10( ICE.LRT.batch(t(Y), matrix(g,nrow=1))$ps)
	}

	pvals

}
