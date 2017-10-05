rm( list=ls() )
library(qvalue)
load( 'Rdata/pars.Rdata' )

myload	<- function( filename ){
	load( filename )
	list( p=10^(-out['pval',1,]), caus=caus_p )
}

pfxn	<- function( p1, p2, tol, caus ){
	n1f	<- sum( ( p1 < tol )[-caus] )
	n2f	<- sum( ( p2 < tol )[-caus] )
	n1t	<- sum( ( p1 < tol )[ caus] )
	n2t	<- sum( ( p2 < tol )[ caus] )
	n12f<- sum( ( p1 < tol & p2 < tol )[-caus] )
	n12t<- sum( ( p1 < tol & p2 < tol )[ caus] )

	c( n12f / n1f, n12f / n2f, n12t / n1t, n12t / n2t )
}

for( tol in tols ){

	alloutfile	<- paste0( 'Rdata/all_psums_', tol, '_ice.Rdata' )
	if( file.exists( alloutfile ) ){
		load( alloutfile )
	} else {
		qmat	<-
		pmat	<- array( NA,
			dim			=c(		2						, type.n, dat.n			, u.n			, 2								,fac.n		,2	, 250 ),
			dimnames=list(c('FP','TP'), types	, dat_types	, sig2_us	, c('unsup','sup'),factypes	,1:2, 1:250 )
		)
	}
	if( F )
	for( dat_type in dat_types )
		for( type in types )
			for( fac in factypes )
				for( meta in 1:2 )
					for( u.i in 1:u.n )
	try({
		nans	<- union(
			which( is.na( pmat['FP',type,dat_type,u.i,meta,fac,1,] ) ),
			which( is.na( pmat['FP',type,dat_type,u.i,meta,fac,2,] ) )
		)
		for( it in nans ){

			loadfile1	<- paste0( 'Rdata/', fac, '_', meta, '_', type, '_', 1, '_',dat_type, '_',u.i, '_', it, '.Rdata' )
			loadfile2	<- paste0( 'Rdata/', fac, '_', meta, '_', type, '_', 2, '_',dat_type, '_',u.i, '_', it, '.Rdata' )
			if( ! file.exists( loadfile1 ) | ! file.exists( loadfile2 ) ) next
			
			o1	<- myload( loadfile1 )
			o2	<- myload( loadfile2 )
			stopifnot( all.equal( o1$caus, o2$caus ) )
			caus	<- o1$caus

			loc	<- pfxn( o1$p, o2$p, tol, caus )
			pmat['FP',type,dat_type,u.i,meta,fac,,it]	<- loc[1:2]
			pmat['TP',type,dat_type,u.i,meta,fac,,it]	<- loc[3:4]

			tryCatch({
			p1	<- qvalue( o1$p )$qvalues
			p2	<- qvalue( o2$p )$qvalues

			loc	<- pfxn( p1, p2, tol, caus )
			qmat['FP',type,dat_type,u.i,meta,fac,,it]	<- loc[1:2]
			qmat['TP',type,dat_type,u.i,meta,fac,,it]	<- loc[3:4]
			})
			rm( caus, o1, o2, p1, p2 )
		}
		cat( sum( !is.na( pmat['TP',type,dat_type,u.i,meta,fac,,] ) ), '\n' )
		save( qmat, pmat, file=alloutfile )
	})

	nruns	<- apply( !is.na(pmat['FP',,,2,,,,]), 1:4, sum )
	print(	 apply( !is.na(pmat['FP',,1,,,'ice',,]), 1:3, sum ) )

	psums	<- apply( pmat, 1:6, mean, na.rm=T )
	qsums	<- apply( qmat, 1:6, mean, na.rm=T )

	save( nruns, qsums, psums, file=paste0( 'Rdata/psums_', tol, '.Rdata' ) )
}
source('plot_fig5.R')
