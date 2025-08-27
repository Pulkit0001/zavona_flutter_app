#!/usr/bin/env node

const fs = require('fs-extra');
const path = require('path');
const { program } = require('commander');

class PostmanToFlutterGenerator {
  constructor() {
    this.collection = null;
    this.outputDir = './generated_services';
    this.serviceName = '';
    this.baseUrl = '';
  }

  /**
   * Parse command line arguments
   */
  parseArguments() {
    program
      .version('1.0.0')
      .description('Generate Flutter service classes from Postman collections')
      .requiredOption('-i, --input <file>', 'Postman collection JSON file')
      .option('-o, --output <dir>', 'Output directory for generated files', './generated_services')
      .option('-n, --name <name>', 'Service class name (will be extracted from collection if not provided)')
      .option('-u, --url <url>', 'Base URL (will be extracted from collection if not provided)')
      .parse();

    const options = program.opts();
    
    if (!fs.existsSync(options.input)) {
      console.error(`Error: Input file ${options.input} does not exist`);
      process.exit(1);
    }

    this.outputDir = options.output;
    this.serviceName = options.name;
    this.baseUrl = options.url;

    return options.input;
  }

  /**
   * Load and parse Postman collection
   */
  async loadCollection(filePath) {
    try {
      const content = await fs.readFile(filePath, 'utf8');
      this.collection = JSON.parse(content);
      
      console.log(`✅ Loaded collection: ${this.collection.info.name}`);
      
      // Extract service name from collection if not provided
      if (!this.serviceName) {
        this.serviceName = this.extractServiceName(this.collection.info.name);
      }
      
      // Extract base URL if not provided
      if (!this.baseUrl) {
        this.baseUrl = this.extractBaseUrl();
      }
      
      console.log(`📝 Service name: ${this.serviceName}`);
      console.log(`🌐 Base URL: ${this.baseUrl}`);
      
    } catch (error) {
      console.error('Error loading collection:', error.message);
      process.exit(1);
    }
  }

  /**
   * Extract service name from collection name
   */
  extractServiceName(collectionName) {
    // Convert to PascalCase and add 'Service' suffix
    const cleaned = collectionName
      .replace(/[^a-zA-Z0-9\s]/g, '')
      .split(/\s+/)
      .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
      .join('');
    
    return cleaned.endsWith('Service') ? cleaned : `${cleaned}Service`;
  }

  /**
   * Extract base URL from collection
   */
  extractBaseUrl() {
    // Look for base URL in collection variables or first request
    if (this.collection.variable) {
      const baseUrlVar = this.collection.variable.find(v => 
        v.key.toLowerCase().includes('baseurl') || 
        v.key.toLowerCase().includes('host') ||
        v.key.toLowerCase().includes('url')
      );
      if (baseUrlVar) return baseUrlVar.value;
    }

    // Extract from first request URL
    const firstRequest = this.findFirstRequest(this.collection.item);
    if (firstRequest && firstRequest.request.url) {
      const url = typeof firstRequest.request.url === 'string' 
        ? firstRequest.request.url 
        : firstRequest.request.url.raw;
      
      try {
        const urlObj = new URL(url);
        return `${urlObj.protocol}//${urlObj.host}`;
      } catch {
        return 'https://api.example.com';
      }
    }

    return 'https://api.example.com';
  }

  /**
   * Find first request in collection (recursive)
   */
  findFirstRequest(items) {
    for (const item of items) {
      if (item.request) {
        return item;
      } else if (item.item) {
        const found = this.findFirstRequest(item.item);
        if (found) return found;
      }
    }
    return null;
  }

  /**
   * Parse all requests from collection
   */
  parseRequests() {
    const requests = [];
    this.extractRequests(this.collection.item, requests);
    console.log(`🔍 Found ${requests.length} requests`);
    return requests;
  }

  /**
   * Extract requests recursively from collection items
   */
  extractRequests(items, requests, folder = '') {
    for (const item of items) {
      if (item.request) {
        // This is a request
        const request = this.parseRequest(item, folder);
        if (request) requests.push(request);
      } else if (item.item) {
        // This is a folder
        const folderName = folder ? `${folder}/${item.name}` : item.name;
        this.extractRequests(item.item, requests, folderName);
      }
    }
  }

  /**
   * Parse individual request
   */
  parseRequest(item, folder) {
    const request = item.request;
    if (!request) return null;

    const url = typeof request.url === 'string' ? request.url : request.url.raw;
    const method = request.method.toUpperCase();
    
    // Extract path from URL
    let path = '';
    try {
      if (typeof request.url === 'object' && request.url.path) {
        path = '/' + request.url.path.join('/');
      } else {
        const urlObj = new URL(url);
        path = urlObj.pathname;
      }
    } catch {
      path = url.replace(this.baseUrl, '').split('?')[0];
    }

    // Generate method name
    const methodName = this.generateMethodName(item.name, method, path);

    // Extract parameters
    const queryParams = this.extractQueryParams(request);
    const bodyParams = this.extractBodyParams(request);
    const pathParams = this.extractPathParams(path);

    return {
      name: item.name,
      folder,
      method,
      path,
      methodName,
      queryParams,
      bodyParams,
      pathParams,
      description: item.description || `${method} ${path}`,
      originalRequest: request
    };
  }

  /**
   * Generate method name from request name and HTTP method
   */
  generateMethodName(requestName, method, path) {
    // Clean request name
    let name = requestName
      .replace(/[^a-zA-Z0-9\s]/g, '')
      .split(/\s+/)
      .map((word, index) => 
        index === 0 
          ? word.toLowerCase() 
          : word.charAt(0).toUpperCase() + word.slice(1).toLowerCase()
      )
      .join('');

    // If name is too generic, use method + path
    if (!name || name.length < 3) {
      const pathParts = path.split('/').filter(p => p && !p.startsWith(':'));
      const lastPart = pathParts[pathParts.length - 1] || 'data';
      
      const methodPrefix = {
        'GET': 'get',
        'POST': 'create',
        'PUT': 'update',
        'PATCH': 'patch',
        'DELETE': 'delete'
      }[method] || method.toLowerCase();

      name = `${methodPrefix}${lastPart.charAt(0).toUpperCase() + lastPart.slice(1)}`;
    }

    return name;
  }

  /**
   * Extract query parameters from request
   */
  extractQueryParams(request) {
    const params = [];
    
    if (request.url && typeof request.url === 'object' && request.url.query) {
      for (const param of request.url.query) {
        // if (param.disabled) continue;
        
        params.push({
          key: param.key,
          type: this.inferParamType(param.value, param.description),
          required: !param.disabled,
          description: param.description || ''
        });
      }
    }

    return params;
  }

  /**
   * Extract body parameters from request
   */
  extractBodyParams(request) {
    const params = [];
    
    if (request.body) {
      if (request.body.mode === 'raw') {
        try {
          const body = JSON.parse(request.body.raw);
          this.extractJsonParams(body, params);
        } catch {
          // Not valid JSON, skip
        }
      } else if (request.body.mode === 'formdata') {
        for (const param of request.body.formdata || []) {
          if (param.disabled) continue;
          
          params.push({
            key: param.key,
            type: param.type === 'file' ? 'File' : this.inferParamType(param.value),
            required: !param.disabled,
            description: param.description || ''
          });
        }
      }
    }

    return params;
  }

  /**
   * Extract parameters from JSON object recursively
   */
  extractJsonParams(obj, params, prefix = '') {
    for (const [key, value] of Object.entries(obj)) {
      const paramKey = prefix ? `${prefix}.${key}` : key;
      
      if (typeof value === 'object' && value !== null && !Array.isArray(value)) {
        this.extractJsonParams(value, params, paramKey);
      } else {
        params.push({
          key: paramKey,
          type: this.inferParamType(value),
          required: true,
          description: ''
        });
      }
    }
  }

  /**
   * Extract path parameters from URL path
   */
  extractPathParams(path) {
    const params = [];
    const matches = path.match(/\{([^}]+)\}|:([^/]+)/g) || [];
    
    for (const match of matches) {
      const key = match.replace(/[{}:]/g, '');
      params.push({
        key,
        type: 'String',
        required: true,
        description: `Path parameter: ${key}`
      });
    }

    return params;
  }

  /**
   * Infer parameter type from value
   */
  inferParamType(value, description = '') {
    if (typeof value === 'number') return 'int';
    if (typeof value === 'boolean') return 'bool';
    if (Array.isArray(value)) return 'List<String>';
    if (value && value.toString().includes('.') && !isNaN(value)) return 'double';
    
    // Check description for hints
    const desc = description.toLowerCase();
    if (desc.includes('email')) return 'String';
    if (desc.includes('id') || desc.includes('count')) return 'int';
    if (desc.includes('price') || desc.includes('amount')) return 'double';
    if (desc.includes('flag') || desc.includes('enabled')) return 'bool';
    
    return 'String';
  }

  /**
   * Generate Flutter service class
   */
  async generateService(requests) {
    const className = this.serviceName;
    const fileName = this.toSnakeCase(className) + '.dart';
    
    let content = this.generateServiceHeader(className);
    // Generate the parameter classes and interceptor in separate files
    const modelsFileName = this.toSnakeCase(this.serviceName) + '_models.dart';
    const interceptorsFileName = this.toSnakeCase(this.serviceName) + '_interceptors.dart';
    
    // Create models file content
    let modelsContent = `import 'package:zavona_flutter_app/core/core.dart';\n\n`;
    modelsContent += this.generateParameterClasses(requests);
    
    // Create interceptors file content
    let interceptorsContent = `import 'package:dio/dio.dart';\n\n`;
    interceptorsContent += `/// Custom interceptor for ${this.serviceName}\n`;
    interceptorsContent += `class CustomInterceptor extends Interceptor {\n`;
    interceptorsContent += `  @override\n`;
    interceptorsContent += `  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {\n`;
    interceptorsContent += `    options.headers['Custom-Header'] = 'CustomValue';\n`;
    interceptorsContent += `    super.onRequest(options, handler);\n`;
    interceptorsContent += `  }\n`;
    interceptorsContent += `}\n`;
    
    // Write models file
    await fs.ensureDir(this.outputDir);
    const modelsFilePath = path.join(this.outputDir, modelsFileName);
    await fs.writeFile(modelsFilePath, modelsContent);
    console.log(`✅ Generated models: ${modelsFilePath}`);
    
    // Write interceptors file
    const interceptorsFilePath = path.join(this.outputDir, interceptorsFileName);
    await fs.writeFile(interceptorsFilePath, interceptorsContent);
    console.log(`✅ Generated interceptors: ${interceptorsFilePath}`);
    
    // Add imports to service file
    content += `import './${path.basename(modelsFileName)}';\n`;
    content += `import './${path.basename(interceptorsFileName)}';\n\n`;
    
    // Generate service class
    content += this.generateServiceClass(className, requests);
    
    // Write to file
    await fs.ensureDir(this.outputDir);
    const filePath = path.join(this.outputDir, fileName);
    await fs.writeFile(filePath, content);
    
    console.log(`✅ Generated service: ${filePath}`);
    return filePath;
  }

  /**
   * Generate service file header
   */
  generateServiceHeader(className) {
    return `import 'package:dartz/dartz.dart';
import 'package:zavona_flutter_app/core/core.dart';
import 'package:dio/dio.dart';

/// Generated service class for ${className}
/// Base URL: ${this.baseUrl}
/// Generated from Postman collection: ${this.collection.info.name}

`;
  }

  /**
   * Generate parameter classes for requests
   */
  generateParameterClasses(requests) {
    let content = '';
    const generatedClasses = new Set();

    for (const request of requests) {
      // Generate query params class
      if (request.queryParams.length > 0) {
        const className = `${this.toPascalCase(request.methodName)}QueryParams`;
        if (!generatedClasses.has(className)) {
          content += this.generateParamClass(className, request.queryParams, 'BaseQueryParams');
          generatedClasses.add(className);
        }
      }

      // Generate body params class
      if (request.bodyParams.length > 0) {
        const className = `${this.toPascalCase(request.methodName)}RequestParams`;
        if (!generatedClasses.has(className)) {
          content += this.generateParamClass(className, request.bodyParams, 'BaseRequestParams');
          generatedClasses.add(className);
        }
      }
    }

    return content;
  }

  /**
   * Generate parameter class
   */
  generateParamClass(className, params, baseClass) {
    let content = `/// ${className} for API request\n`;
    content += `class ${className} extends ${baseClass} {\n`;
    
    // Properties
    for (const param of params) {
      const optional = !param.required ? '?' : '';
      content += `  final ${param.type}${optional} ${this.toCamelCase(param.key)};\n`;
    }
    
    content += '\n';
    
    // Constructor
    content += `  ${className}({\n`;
    for (const param of params) {
      const required = param.required ? 'required ' : '';
      content += `    ${required}this.${this.toCamelCase(param.key)},\n`;
    }
    content += '  });\n\n';
    
    // toJson method
    content += '  @override\n';
    content += '  Map<String, dynamic> toJson() {\n';
    content += '    final Map<String, dynamic> data = {};\n';
    
    for (const param of params) {
      const key = this.toCamelCase(param.key);
      if (param.required) {
        content += `    data['${param.key}'] = ${key};\n`;
      } else {
        content += `    if (${key} != null) data['${param.key}'] = ${key};\n`;
      }
    }
    
    content += '    return data;\n';
    content += '  }\n';
    content += '}\n\n';
    
    return content;
  }

  /**
   * Generate main service class
   */
  generateServiceClass(className, requests) {
    let content = `/// ${className} with CRUD operations using BaseApiService\n`;
    content += `class ${className} with BaseApiService {\n`;
    content += `  final String _baseUrl;\n\n`;
    content += `  ${className}({\n`;
    content += `    required String baseUrl,\n`;
    content += `  }) : _baseUrl = baseUrl;\n\n`;

    // Add custom interceptors
    content += `  @override\n`;
    content += `  void addCustomInterceptors(Dio dio) {\n`;
    content += `    dio.interceptors.add(CustomInterceptor());\n`;
    content += `  }\n\n`;

    // Generate methods
    for (const request of requests) {
      content += this.generateServiceMethod(request);
      content += '\n';
    }
    
    content += '}\n';
    
    return content;
  }

  /**
   * Generate individual service method
   */
  generateServiceMethod(request) {
    const methodName = request.methodName;
    const httpMethod = request.method.toLowerCase();
    const hasQueryParams = request.queryParams.length > 0;
    const hasBodyParams = request.bodyParams.length > 0;
    const hasPathParams = request.pathParams.length > 0;
    
    let content = `  /// ${request.description}\n`;
    content += `  /// Returns \`Either<String, Map<String, dynamic>?>\` where:\n`;
    content += `  /// - Left: Error message\n`;
    content += `  /// - Right: Response data\n`;
    content += `  Future<Either<String, Map<String, dynamic>?>> ${methodName}(`;
    if(hasBodyParams || hasPathParams || hasQueryParams){
        content += ` {\n`;
    }else{
        content += `) async {\n`;
    }
    // Method parameters
    if (hasPathParams) {
      for (const param of request.pathParams) {
        content += `    required String ${this.toCamelCase(param.key)},\n`;
      }
    }
    
    if (hasQueryParams) {
      const className = `${this.toPascalCase(methodName)}QueryParams`;
      content += `    ${className}? queryParams,\n`;
    }
    
    if (hasBodyParams) {
      const className = `${this.toPascalCase(methodName)}RequestParams`;
      content += `    ${className}? requestParams,\n`;
    }
    if(hasBodyParams || hasPathParams || hasQueryParams){
       content += '  }) async {\n';
    }
    
    content += '    try {\n';
    
    // Build endpoint URL
    let endpoint = request.path;
    for (const param of request.pathParams) {
      const paramName = this.toCamelCase(param.key);
      endpoint = endpoint.replace(`{${param.key}}`, `\$${paramName}`);
      endpoint = endpoint.replace(`:${param.key}`, `\$${paramName}`);
    }
    
    content += `      final response = await ${httpMethod}`;
    
    // Add generic type if needed
    if (hasQueryParams || hasBodyParams) {
      const paramType = hasBodyParams 
        ? `${this.toPascalCase(methodName)}RequestParams`
        : `${this.toPascalCase(methodName)}QueryParams`;
      content += `<${paramType}>`;
    }
    
    content += '(\n';
    content += `        endpoint: '\$_baseUrl${endpoint}',\n`;
    
    if (hasQueryParams) {
      content += '        queryParams: queryParams,\n';
    }
    
    if (hasBodyParams) {
      content += '        requestParams: requestParams,\n';
    }
    
    content += '      );\n';
    content += '      return Right(response);\n';
    content += '    } on ApiException catch (e) {\n';
    content += "      return Left('API Error: \${e.message}');\n";
    content += '    } catch (e) {\n';
    content += "      return Left('Unexpected error: \${e.toString()}');\n";
    content += '    }\n';
    content += '  }\n';
    
    return content;
  }

/**
 * Utility: Convert to camelCase
 */
toCamelCase(str) {
    return str
        .toLowerCase()
        .replace(/[^a-zA-Z0-9]+(.)/g, (match, chr) => chr.toUpperCase())
        .replace(/^[A-Z]/, firstChar => firstChar.toLowerCase());
}

  /**
   * Utility: Convert to PascalCase
   */
  toPascalCase(str) {
    const camel = this.toCamelCase(str);
    return camel.charAt(0).toUpperCase() + camel.slice(1);
  }

  /**
   * Utility: Convert to snake_case
   */
  toSnakeCase(str) {
    return str.replace(/[A-Z]/g, letter => `_${letter.toLowerCase()}`).replace(/^_/, '');
  }

  /**
   * Main generation process
   */
  async generate() {
    console.log('🚀 Starting Postman to Flutter Service Generator...\n');
    
    const inputFile = this.parseArguments();
    await this.loadCollection(inputFile);
    
    const requests = this.parseRequests();
    if (requests.length === 0) {
      console.log('⚠️  No requests found in collection');
      return;
    }
    
    await this.generateService(requests);
    
    console.log('\n✅ Generation completed successfully!');
    console.log(`📁 Output directory: ${this.outputDir}`);
    console.log('\nNext steps:');
    console.log('1. Copy the generated file to your Flutter project');
    console.log('2. Update import paths as needed');
    console.log('3. Review and customize the generated code');
  }
}

// Run the generator
if (require.main === module) {
  const generator = new PostmanToFlutterGenerator();
  generator.generate().catch(console.error);
}

module.exports = PostmanToFlutterGenerator;
