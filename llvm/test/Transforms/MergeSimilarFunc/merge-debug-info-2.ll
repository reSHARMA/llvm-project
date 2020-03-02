; RUN: opt -S -mergesimilarfunc -mergesimilarfunc-diff-min-insts=5 < %s | FileCheck %s
; This used to fail with assertion in CloneFunction
; REQUIRES: asserts
; CHECK-LABEL: @foo__merged(

target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-ios8.0.0"

%struct.wibble = type { %struct.wibble.0*, %struct.wibble* }
%struct.wibble.0 = type { i64*, i8*, i64*, i64*, %struct.eggs*, %struct.wibble* }
%struct.eggs = type { %struct.wombat*, %struct.eggs* }
%struct.wombat = type { i8*, %struct.blam*, %struct.blam* }
%struct.blam = type { i8*, %struct.blam* }
%struct.snork = type { %struct.bar*, %struct.snork* }
%struct.bar = type { i64*, i8* }

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #0

; Function Attrs: minsize nounwind optsize ssp uwtable
define hidden void @foo(%struct.wibble* %arg) #1 align 2 !dbg !4 {
bb:
  %tmp = alloca %struct.wibble*, align 8
  %tmp2 = load %struct.wibble*, %struct.wibble** %tmp, align 8, !dbg !12
  %tmp3 = icmp ne %struct.wibble* %tmp2, null, !dbg !13
  br i1 %tmp3, label %bb4, label %bb13, !dbg !14

bb4:                                              ; preds = %bb
  call void @foo.1() #3, !dbg !26
  unreachable

bb13:                                             ; preds = %bb
  ret void, !dbg !27
}

; Function Attrs: minsize nounwind optsize ssp uwtable
declare hidden void @foo.1() #1 align 2

; Function Attrs: minsize nounwind optsize ssp uwtable
define void @quux() unnamed_addr #1 align 2 !dbg !28 {
bb:
  ret void
}

; Function Attrs: minsize nounwind optsize ssp uwtable
define hidden void @baz(%struct.snork* %arg) #1 align 2 !dbg !30 {
bb:
  %tmp = alloca %struct.snork*, align 8
  %tmp2 = load %struct.snork*, %struct.snork** %tmp, align 8, !dbg !31
  %tmp3 = icmp ne %struct.snork* %tmp2, null, !dbg !32
  br i1 %tmp3, label %bb4, label %bb13, !dbg !33

bb4:                                              ; preds = %bb
  call void @blam() #3, !dbg !42
  unreachable

bb13:                                             ; preds = %bb
  ret void, !dbg !43
}

; Function Attrs: minsize nounwind optsize ssp uwtable
declare hidden void @blam() #1 align 2

attributes #0 = { argmemonly nounwind }
attributes #1 = { minsize nounwind optsize ssp uwtable }
attributes #2 = { nounwind }
attributes #3 = { minsize optsize }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "(based on LLVM 5.0.0)", isOptimized: true, runtimeVersion: 0, emissionKind: LineTablesOnly)
!1 = !DIFile(filename: "foo.cpp", directory: "/")
!2 = !{i32 2, !"Debug Info Version", i32 3}
!3 = !{i32 7, !"PIC Level", i32 2}
!4 = distinct !DISubprogram(name: "delete", scope: !5, file: !5, line: 31, type: !6, isLocal: false, isDefinition: true, scopeLine: 32, flags: DIFlagPrototyped, isOptimized: true, unit: !0)
!5 = !DIFile(filename: "foo.h", directory: "/")
!6 = !DISubroutineType(types: !7)
!7 = !{}
!9 = !{!"any pointer", !10, i64 0}
!10 = !{!"omnipotent char", !11, i64 0}
!11 = !{!"Simple C++ TBAA"}
!12 = !DILocation(line: 33, column: 11, scope: !4)
!13 = !DILocation(line: 33, column: 16, scope: !4)
!14 = !DILocation(line: 33, column: 5, scope: !4)
!21 = !{!"_ZTSN", !9, i64 0, !9, i64 8}
!23 = !DILocation(line: 37, column: 25, scope: !4)
!24 = !DILocation(line: 37, column: 31, scope: !4)
!25 = !{!21, !9, i64 0}
!26 = !DILocation(line: 37, column: 7, scope: !4)
!27 = !DILocation(line: 41, column: 3, scope: !4)
!28 = distinct !DISubprogram(name: "~destruct", scope: !29, file: !29, line: 31, type: !6, isLocal: false, isDefinition: true, scopeLine: 32, flags: DIFlagPrototyped, isOptimized: true, unit: !0)
!29 = !DIFile(filename: "bar.h", directory: "/")
!30 = distinct !DISubprogram(name: "delete", scope: !5, file: !5, line: 31, type: !6, isLocal: false, isDefinition: true, scopeLine: 32, flags: DIFlagPrototyped, isOptimized: true, unit: !0)
!31 = !DILocation(line: 33, column: 11, scope: !30)
!32 = !DILocation(line: 33, column: 16, scope: !30)
!33 = !DILocation(line: 33, column: 5, scope: !30)
!40 = !DILocation(line: 37, column: 25, scope: !30)
!41 = !DILocation(line: 37, column: 31, scope: !30)
!42 = !DILocation(line: 37, column: 7, scope: !30)
!43 = !DILocation(line: 41, column: 3, scope: !30)
