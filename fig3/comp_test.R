rm( list=ls() )
library(qvalue)
load( 'Rdata/pars.Rdata' )

for( tol in tols ){

	alloutfile	<- paste0( 'Rdata/all_psums_', tol, '_new.Rdata' )
	if( file.exists( alloutfile ) ){
		load( alloutfile )
	} else {
		qmat	<-
		pmat	<- array( NA,
			dim			=c(		2						,type.n	,2								,fac.n		,length(Ks)	, 250),
			dimnames=list(c('FP','TP'),types	,c('unsup','sup')	,factypes	,Ks					, 1:250)
		)
	}
	for( type in types )
		for( meta in 1:2 )
			for( fac in factypes )
				for( K.i in seq( along=Ks ) )
	{
		if( K.i > 1 & fac == 'ice' ) next

		nans	<- which(is.na( qmat['FP',type,meta,fac,K.i,] ))
		if( length(nans)==0 ) next

		cat( type, meta, fac, '  ' )

		for( it in nans ) tryCatch({
			loadfile	<- paste0( 'Rdata/', fac, '_', meta, '_', type, '_', it, '_', Ks[K.i], '_test.Rdata' )
			if( ! file.exists( loadfile ) ) next
			load( loadfile )

			pvals	<- 10^(-out['pval',1,])
			pmat['FP',type,meta,fac,K.i,it]	<- mean( pvals[-caus_p] < tol )
			pmat['TP',type,meta,fac,K.i,it]	<- mean( pvals[caus_p]  < tol )

			qvals		<- qvalue( pvals )$qvalues
			qmat['FP',type,meta,fac,K.i,it]	<- mean( qvals[-caus_p] < tol )
			qmat['TP',type,meta,fac,K.i,it]	<- mean( qvals[caus_p]  < tol )

			rm( out, pvals, qvals, caus_p )
		}, error=function(e){ print(e); print( loadfile) })
		cat( sum( !is.na( pmat['TP',type,meta,fac,1,] ) ), '\n' )
		save( qmat, pmat, file=alloutfile )
	}
	nruns	<- apply( !is.na(pmat[1,,,,1,]), 1:3, sum )
	psums	<- apply( pmat, 1:5, mean, na.rm=T )
	qsums	<- apply( qmat, 1:5, mean, na.rm=T )
	save( nruns, qsums, psums, file=paste0( 'Rdata/psums_', tol, '_new.Rdata' ) )
}
source('plot_fig3.R')
