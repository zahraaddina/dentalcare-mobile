import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/app_theme.dart';
import '../models/app_models.dart';

String dateText(String iso) {
  final d=DateTime.tryParse(iso);
  return d==null?iso:DateFormat('d MMMM yyyy','id_ID').format(d);
}
String shortDate(String iso) {
  final d=DateTime.tryParse(iso);
  return d==null?iso:DateFormat('EEE, d MMM','id_ID').format(d);
}
void snack(BuildContext context,String message,{bool error=false}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(message),backgroundColor:error?C.red:C.deep,behavior:SnackBarBehavior.floating,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12))));
}

class SheetCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const SheetCard({super.key,required this.child,this.padding=const EdgeInsets.all(18)});
  @override Widget build(BuildContext context)=>Container(
    padding:padding,
    decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(22),border:Border.all(color:C.line),boxShadow:[BoxShadow(color:C.deep.withValues(alpha:.025),offset:const Offset(0,6),blurRadius:18)]),
    child:child,
  );
}

class HeaderText extends StatelessWidget {
  final String title,subtitle;
  const HeaderText(this.title,this.subtitle,{super.key});
  @override Widget build(BuildContext context)=>Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Text(title,style:const TextStyle(fontSize:23,fontWeight:FontWeight.w700,letterSpacing:-.5,color:C.ink)),
    const SizedBox(height:5),Text(subtitle,style:const TextStyle(color:C.muted,fontSize:12.5,height:1.5)),
  ]);
}

class SectionTitle extends StatelessWidget {
  final String text;
  final Widget? trailing;
  const SectionTitle(this.text,{super.key,this.trailing});
  @override Widget build(BuildContext context)=>Row(children:[Expanded(child:Text(text,style:const TextStyle(fontSize:17,fontWeight:FontWeight.w700))),if(trailing!=null)trailing!]);
}

class LabeledValue extends StatelessWidget {
  final String label,value;
  const LabeledValue(this.label,this.value,{super.key});
  @override Widget build(BuildContext context)=>Padding(padding:const EdgeInsets.symmetric(vertical:7),child:Row(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Expanded(flex:2,child:Text(label,style:const TextStyle(fontSize:12,color:C.muted))),
    Expanded(flex:3,child:Text(value,textAlign:TextAlign.right,style:const TextStyle(fontSize:12,fontWeight:FontWeight.w600,color:C.ink))),
  ]));
}

class StatusPill extends StatelessWidget {
  final String status;
  const StatusPill(this.status,{super.key});
  @override Widget build(BuildContext context){
    final Color color= status=='completed'?C.green:status=='cancelled'||status=='no_show'?C.red:C.gold;
    return Container(padding:const EdgeInsets.symmetric(horizontal:11,vertical:6),decoration:BoxDecoration(color:color.withValues(alpha:.10),borderRadius:BorderRadius.circular(40)),child:Text(statusLabel(status),style:TextStyle(color:color,fontSize:10,fontWeight:FontWeight.w700)));
  }
}

class EmptyView extends StatelessWidget {
  final IconData icon;
  final String title,description;
  final Widget? action;
  const EmptyView({super.key,required this.icon,required this.title,required this.description,this.action});
  @override Widget build(BuildContext context)=>Padding(padding:const EdgeInsets.symmetric(vertical:38,horizontal:12),child:Column(children:[
    CircleAvatar(radius:36,backgroundColor:C.mint,child:Icon(icon,color:C.green,size:32)),
    const SizedBox(height:18),Text(title,textAlign:TextAlign.center,style:const TextStyle(fontSize:16,fontWeight:FontWeight.w700)),
    const SizedBox(height:6),Text(description,textAlign:TextAlign.center,style:const TextStyle(color:C.muted,fontSize:12.5,height:1.6)),
    if(action!=null)...[const SizedBox(height:20),action!],
  ]));
}

class PoliIcon extends StatelessWidget {
  final Poli poli;
  final double size;
  const PoliIcon(this.poli,{super.key,this.size=50});
  @override Widget build(BuildContext context)=>Container(width:size,height:size,decoration:BoxDecoration(color:C.mint,borderRadius:BorderRadius.circular(size*.3)),child:Icon([Icons.medical_services_outlined,Icons.health_and_safety_outlined,Icons.child_care_rounded][poli.iconId],color:C.green,size:size*.48));
}

class FieldLabel extends StatelessWidget {
  final String label;
  final Widget child;
  const FieldLabel(this.label,{super.key,required this.child});
  @override Widget build(BuildContext context)=>Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(label,style:const TextStyle(fontSize:12,fontWeight:FontWeight.w600)),const SizedBox(height:8),child,const SizedBox(height:17)]);
}

Widget pagePadding(Widget child)=>Padding(padding:const EdgeInsets.fromLTRB(20,18,20,26),child:child);

class StepBar extends StatelessWidget {
  final int current;
  const StepBar({super.key,required this.current});
  @override Widget build(BuildContext context)=>Row(children:List.generate(3,(i)=>Expanded(child:Padding(padding:EdgeInsets.only(right:i==2?0:7),child:Column(children:[Container(height:5,decoration:BoxDecoration(color:i<=current?C.green:C.line,borderRadius:BorderRadius.circular(8))),const SizedBox(height:7),Text(['1. Keluhan','2. Jadwal','3. Konfirmasi'][i],style:TextStyle(fontSize:10,fontWeight:i==current?FontWeight.w700:FontWeight.w500,color:i<=current?C.green:C.muted))])))));
}
