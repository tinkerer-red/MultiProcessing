{
  "resourceType": "GMExtension",
  "resourceVersion": "1.2",
  "name": "libsysinfo",
  "androidactivityinject": "",
  "androidclassname": "",
  "androidcodeinjection": "",
  "androidinject": "",
  "androidmanifestinject": "",
  "androidPermissions": [],
  "androidProps": false,
  "androidsourcedir": "",
  "author": "",
  "classname": "",
  "copyToTargets": 194,
  "date": "2023-06-01T14:21:37.4440079-04:00",
  "description": "",
  "exportToGame": true,
  "extensionVersion": "0.0.1",
  "files": [
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","constants":[],"copyToTargets":194,"filename":"libsysinfo.dll","final":"","functions":[
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"os_kernel_name","argCount":0,"args":[],"documentation":"","externalName":"os_kernel_name","help":"os_kernel_name()","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"os_device_name","argCount":0,"args":[],"documentation":"","externalName":"os_device_name","help":"os_device_name()","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"os_kernel_release","argCount":0,"args":[],"documentation":"","externalName":"os_kernel_release","help":"os_kernel_release()","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"os_kernel_version","argCount":0,"args":[],"documentation":"","externalName":"os_kernel_version","help":"os_kernel_version()","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"os_architecture","argCount":0,"args":[],"documentation":"","externalName":"os_architecture","help":"os_architecture()","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"os_product_name","argCount":0,"args":[],"documentation":"","externalName":"os_product_name","help":"os_product_name()","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"memory_totalram","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"memory_totalram","help":"memory_totalram(human_readable?)","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"memory_freeram","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"memory_freeram","help":"memory_freeram(human_readable?)","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"memory_usedram","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"memory_usedram","help":"memory_usedram(human_readable?)","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"memory_totalswap","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"memory_totalswap","help":"memory_totalswap(human_readable?)","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"memory_freeswap","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"memory_freeswap","help":"memory_freeswap(human_readable?)","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"memory_usedswap","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"memory_usedswap","help":"memory_usedswap(human_readable?)","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"gpu_manufacturer","argCount":0,"args":[],"documentation":"","externalName":"gpu_manufacturer","help":"gpu_manufacturer()","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"gpu_renderer","argCount":0,"args":[],"documentation":"","externalName":"gpu_renderer","help":"gpu_renderer()","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"memory_totalvram","argCount":0,"args":[
            2,
          ],"documentation":"","externalName":"memory_totalvram","help":"memory_totalvram(human_readable?)","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"cpu_vendor","argCount":0,"args":[],"documentation":"","externalName":"cpu_vendor","help":"cpu_vendor()","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"cpu_processor","argCount":0,"args":[],"documentation":"","externalName":"cpu_processor","help":"cpu_processor()","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"cpu_processor_count","argCount":0,"args":[],"documentation":"","externalName":"cpu_processor_count","help":"cpu_processor_count()","hidden":false,"kind":1,"returnType":1,},
        {"resourceType":"GMExtensionFunction","resourceVersion":"1.0","name":"cpu_core_count","argCount":0,"args":[],"documentation":"","externalName":"cpu_core_count","help":"cpu_core_count()","hidden":false,"kind":1,"returnType":1,},
      ],"init":"","kind":1,"order":[
        {"name":"os_kernel_name","path":"extensions/libsysinfo/libsysinfo.yy",},
        {"name":"os_device_name","path":"extensions/libsysinfo/libsysinfo.yy",},
        {"name":"os_kernel_release","path":"extensions/libsysinfo/libsysinfo.yy",},
        {"name":"os_kernel_version","path":"extensions/libsysinfo/libsysinfo.yy",},
        {"name":"os_architecture","path":"extensions/libsysinfo/libsysinfo.yy",},
        {"name":"os_product_name","path":"extensions/libsysinfo/libsysinfo.yy",},
        {"name":"memory_totalram","path":"extensions/libsysinfo/libsysinfo.yy",},
        {"name":"memory_freeram","path":"extensions/libsysinfo/libsysinfo.yy",},
        {"name":"memory_usedram","path":"extensions/libsysinfo/libsysinfo.yy",},
        {"name":"memory_totalswap","path":"extensions/libsysinfo/libsysinfo.yy",},
        {"name":"memory_freeswap","path":"extensions/libsysinfo/libsysinfo.yy",},
        {"name":"memory_usedswap","path":"extensions/libsysinfo/libsysinfo.yy",},
        {"name":"memory_totalvram","path":"extensions/libsysinfo/libsysinfo.yy",},
        {"name":"gpu_manufacturer","path":"extensions/libsysinfo/libsysinfo.yy",},
        {"name":"gpu_renderer","path":"extensions/libsysinfo/libsysinfo.yy",},
        {"name":"cpu_vendor","path":"extensions/libsysinfo/libsysinfo.yy",},
        {"name":"cpu_processor","path":"extensions/libsysinfo/libsysinfo.yy",},
        {"name":"cpu_processor_count","path":"extensions/libsysinfo/libsysinfo.yy",},
        {"name":"cpu_core_count","path":"extensions/libsysinfo/libsysinfo.yy",},
      ],"origname":"","ProxyFiles":[
        {"resourceType":"GMProxyFile","resourceVersion":"1.0","name":"libsysinfo.dylib","TargetMask":1,},
        {"resourceType":"GMProxyFile","resourceVersion":"1.0","name":"libsysinfo.so","TargetMask":7,},
        {"resourceType":"GMProxyFile","resourceVersion":"1.0","name":"libsysinfo_arm64.so","TargetMask":7,},
        {"resourceType":"GMProxyFile","resourceVersion":"1.0","name":"libsysinfo_arm.so","TargetMask":7,},
      ],"uncompress":false,"usesRunnerInterface":false,},
    {"resourceType":"GMExtensionFile","resourceVersion":"1.0","name":"","constants":[],"copyToTargets":0,"filename":"libsysinfo.zip","final":"","functions":[],"init":"","kind":4,"order":[],"origname":"","ProxyFiles":[],"uncompress":false,"usesRunnerInterface":false,},
  ],
  "gradleinject": "",
  "hasConvertedCodeInjection": true,
  "helpfile": "",
  "HTML5CodeInjection": "",
  "html5Props": false,
  "IncludedResources": [],
  "installdir": "",
  "iosCocoaPodDependencies": "",
  "iosCocoaPods": "",
  "ioscodeinjection": "",
  "iosdelegatename": "",
  "iosplistinject": "",
  "iosProps": false,
  "iosSystemFrameworkEntries": [],
  "iosThirdPartyFrameworkEntries": [],
  "license": "",
  "maccompilerflags": "",
  "maclinkerflags": "",
  "macsourcedir": "",
  "options": [],
  "optionsFile": "options.json",
  "packageId": "",
  "parent": {
    "name": "SystemInfo",
    "path": "folders/_Libraries/SystemInfo.yy",
  },
  "productId": "",
  "sourcedir": "",
  "supportedTargets": -1,
  "tvosclassname": null,
  "tvosCocoaPodDependencies": "",
  "tvosCocoaPods": "",
  "tvoscodeinjection": "",
  "tvosdelegatename": null,
  "tvosmaccompilerflags": "",
  "tvosmaclinkerflags": "",
  "tvosplistinject": "",
  "tvosProps": false,
  "tvosSystemFrameworkEntries": [],
  "tvosThirdPartyFrameworkEntries": [],
}