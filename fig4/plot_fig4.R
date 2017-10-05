rm( list=ls() )
load( 'Rdata/pars.Rdata' )
source( 'plot_fxns.R' )

dat_type	<- 'real'
load( paste0( 'Rdata/psums_', .01, '.Rdata' ) )
for( type in types ){
	print( type )
	try( print( nruns[type,dat_type,,] ) )
}

plotfxn( '~/figs/fig4.pdf'	, psums['FP',,dat_type,,,] )
plotfxn( '~/figs/fig4log.pdf', log10( psums['FP',,dat_type,,,] ),  log=T, ylim=c( log10(.01)-.2, 0 ) )
plotfxn( '~/figs/sfig10.pdf'	, psums['FP',,dat_type,,,],  types=c( 'hix1', 'dense,hix' ) )
plotfxn( '~/figs/sfig8.pdf', qsums['FP',,dat_type,,,] )
plotfxn( '~/figs/sfig11.pdf', qsums['TP',,dat_type,,,], ylab='True Positive Rate' )
plotfxn( '~/figs/sfig11a.pdf',qsums['TP',,dat_type,,,], ylab='True Positive Rate',  types=c( 'hix1', 'dense,hix' ) )
rm( psums, qsums )

load( paste0( 'Rdata/psums_', .001, '.Rdata' ) )
plotfxn( '~/figs/sfig9.pdf', log10( psums['FP',,dat_type,,,] ),  log=T, ylim=c( log10(.001)-.2, 0 ) )
rm( psums, qsums )

load( paste0( 'Rdata/psums_', .05, '.Rdata' ) )
plotfxn( '~/figs/sfig9a.pdf', psums['FP',,dat_type,,,] )
rm( psums, qsums )
