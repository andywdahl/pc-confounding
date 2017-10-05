rm( list=ls() )
library(qvalue)
load( 'Rdata/pars.Rdata' )
for( tol in tols ){
	alloutfile	<- paste0( 'Rdata/all_psums_', tol, '.Rdata' )
	if( file.exists( alloutfile ) ){
		load( alloutfile )
	} else {
		qmat	<-
		pmat	<- array( NA,
			dim			=c(		2						, type.n, dat.n			, r.n		, 2							,fac.n		, 250 ),
			dimnames=list(c('FP','TP'), types	, dat_types	, rho2s	, c('unsup','sup'),factypes	, 1:250 )
		)
	}
	for( dat_type in dat_types )
		for( type in types )
			for( fac in factypes )
				for( meta in 1:2 )
					for( r.i in 1:r.n )
	{
		nans	<- which( is.na( pmat['FP',type,dat_type,r.i,meta,fac,] ) )
		if( length( nans ) == 0 )
			next
		for( it in nans )tryCatch({
			loadfile	<- paste0( 'Rdata/', fac, '_', meta, '_', type, '_',dat_type, '_',r.i, '_', it, '.Rdata' )
			if( ! file.exists( loadfile ) ) next
			load( loadfile )

			pmat['FP',type,dat_type,r.i,meta,fac,it]	<- mean( 10^(-out['pval',1,-caus_p]) < tol )
			pmat['TP',type,dat_type,r.i,meta,fac,it]	<- mean( 10^(-out['pval',1,caus_p] ) < tol )

			tryCatch({
			qobj		<- qvalue( 10^(-out['pval',1,]) )
			qmat['FP',type,dat_type,r.i,meta,fac,it]	<- mean( qobj$qvalues[-caus_p] < tol )
			qmat['TP',type,dat_type,r.i,meta,fac,it]	<- mean( qobj$qvalues[caus_p]  < tol )
			rm( caus, out )
			}, error=function(e) print(e) )
		}, error=function(e) print( loadfile ) )
		cat( type,dat_type,r.i,meta,fac, '\n',  sum( !is.na( pmat['TP',type,dat_type,r.i,meta,fac,] ) ), '\n' )
		save( qmat, pmat, file=alloutfile )
	}
	nruns	<- apply( !is.na(pmat['TP',,,2,,,]), 1:4, sum )
	psums	<- apply( pmat, 1:6, mean, na.rm=T )
	qsums	<- apply( qmat, 1:6, mean, na.rm=T )
	save( nruns, qsums, psums, file=paste0( 'Rdata/psums_', tol, '.Rdata' ) )
}
source('plot_fig4.R')
